import 'package:darq/darq.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/order.dart';
import 'package:injector/injector.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

// TEMP DIAGNOSTIC: prints the SignalR/notification lifecycle to the flutter log.
// Remove once the notification flow is confirmed working end-to-end.
// ignore: avoid_print
void _nlog(String msg) => print('[NOTIF] $msg');

class NotificationsManager implements INotificationsManager {
  static const _hubUrl = "https://eatmed.cloud/hub/notification";
  static const _maxConnectAttempts = 5;

  HubConnection? connection;
  final _stream = BehaviorSubject<List<APINotification>>.seeded([]);
  final _status = BehaviorSubject<NotificationConnectionStatus>.seeded(
      NotificationConnectionStatus.connecting);
  final _string = Injector.appInstance.get<IStrings>();

  /// Guards against overlapping [initialize] calls (login + token refresh can
  /// both fire) that would otherwise leave two racing connections.
  bool _connecting = false;

  /// Set while we intentionally tear the connection down so the `onclose`
  /// handler doesn't report it as an error.
  bool _intentionalClose = false;

  void digestNotificaitons(Object notifications) {
    if ((notifications as List<dynamic>).isEmpty) {
      return;
    }

    var notificationFactory =
        Injector.appInstance.get<IModelFactory<APINotification>>();
    var orderFactory = Injector.appInstance.get<IModelFactory<Order>>();

    final parsed = <APINotification>[];
    for (final e in notifications) {
      try {
        final notification = notificationFactory.fromJson(e);
        switch (notification.type) {
          case NotificationType.agentOrderCanceled:
            final order = orderFactory.fromJson(notification.object!);
            notification.body = _string.getNotificationMessage(
                NotificationType.agentOrderCanceled, order);
            break;
          case NotificationType.userOrderStatusChanged:
            final order = orderFactory.fromJson(notification.object!["order"]);
            final oldStatus =
                OrderStatus.values[notification.object!["oldStatus"]];
            notification.body = _string.getNotificationMessage(
                NotificationType.userOrderStatusChanged, order, oldStatus);
            break;
          case NotificationType.userOrderPriceChanged:
            final order = orderFactory.fromJson(notification.object!);
            notification.body = _string.getNotificationMessage(
                NotificationType.userOrderPriceChanged, order);
            break;
        }
        parsed.add(notification);
      } catch (e) {
        // Skip a single malformed notification rather than failing the whole
        // batch (which would otherwise surface as the screen's error state).
        _nlog('digest skipped a malformed notification: $e');
        continue;
      }
    }

    if (parsed.isEmpty) return;
    _stream.add((_stream.value).concat(parsed).toList());
  }

  /// The notification types the current role should receive.
  List<NotificationType> _typesFor(LoginState? status) {
    if (status == LoginState.agent) {
      return [NotificationType.agentOrderCanceled];
    } else if (status == LoginState.user) {
      // Clients receive BOTH status changes and price/payment changes — each is
      // a separate hub group, so we must subscribe to every one of them.
      return [
        NotificationType.userOrderStatusChanged,
        NotificationType.userOrderPriceChanged,
      ];
    }
    return const [];
  }

  /// Pulls the current buffer from the hub for whichever role is logged in.
  /// Replaces the list (rather than appending) so a reconnect can't duplicate
  /// the already-buffered notifications.
  Future<void> subscribe() async {
    if (connection == null) return;
    final auth = Injector.appInstance.get<IAuth>();
    final status = auth.isLoggedIn();
    final types = _typesFor(status);
    if (types.isEmpty) {
      _nlog('subscribe() skipped: loginState=$status');
      return;
    }

    try {
      // Reset once, then merge the buffer of every subscribed type.
      _stream.add([]);
      for (final type in types) {
        _nlog('subscribe() invoking Subscribe(${type.name}) as $status');
        final result =
            await connection!.invoke("Subscribe", args: [type.index]);
        final count =
            result == null ? "null" : "${(result as List).length} item(s)";
        _nlog('Subscribe(${type.name}) returned: $count');
        digestNotificaitons(result ?? []);
      }
    } catch (e) {
      _nlog('Subscribe FAILED: $e');
      _status.add(NotificationConnectionStatus.error);
    }
  }

  @override
  Future initialize() async {
    if (_connecting) return;
    _connecting = true;
    _setupSignalrLogging();
    try {
      _status.add(NotificationConnectionStatus.connecting);
      if (connection != null) {
        await disconnect();
      }

      final auth = Injector.appInstance.get<IAuth>();
      final token = await auth.getAccessToken();
      _nlog(
          'initialize() token length=${token.length}, loginState=${auth.isLoggedIn()}');
      connection = HubConnectionBuilder()
          .withUrl(_hubUrl,
              options: HttpConnectionOptions(
                  // Read the token live so reconnects/negotiations always use
                  // the freshest JWT instead of a stale snapshot.
                  accessTokenFactory: () => auth.getAccessToken(),
                  // Pin to WebSockets. The Server-Sent-Events fallback is broken
                  // on this signalr_netcore version: its `sse_channel` dependency
                  // rebuilds the request URL with `Uri.replace(queryParameters:)`,
                  // which wipes out the `access_token` (and connection id) query
                  // params — so SSE always hits the hub unauthenticated. The
                  // WebSocket transport appends access_token to the query
                  // correctly and requires the nginx `/hub/` location to forward
                  // the upgrade (proxy_set_header Connection "upgrade").
                  transport: HttpTransportType.WebSockets))
          .configureLogging(Logger("SignalR"))
          .withAutomaticReconnect()
          .build();

      connection!.on("OnNotificationReceived", (arguments) {
        _nlog('OnNotificationReceived: ${arguments?.length ?? 0} arg(s)');
        digestNotificaitons([arguments![0]!]);
      });
      connection!.onreconnecting(({error}) {
        _nlog('onreconnecting: $error');
        _status.add(NotificationConnectionStatus.connecting);
      });
      connection!.onreconnected(({connectionId}) async {
        _nlog('onreconnected: $connectionId');
        _status.add(NotificationConnectionStatus.connected);
        await subscribe();
      });
      connection!.onclose(({error}) {
        _nlog('onclose (intentional=$_intentionalClose): $error');
        if (!_intentionalClose) {
          _status.add(NotificationConnectionStatus.error);
        }
      });

      await _connectWithRetries();
    } finally {
      _connecting = false;
    }
  }

  Future<void> _connectWithRetries() async {
    for (var attempt = 1; attempt <= _maxConnectAttempts; attempt++) {
      try {
        _nlog('start() attempt $attempt/$_maxConnectAttempts');
        await connection!.start();
        _nlog('start() SUCCEEDED (state=${connection!.state})');
        _status.add(NotificationConnectionStatus.connected);
        await subscribe();
        return;
      } catch (e) {
        _nlog('start() attempt $attempt FAILED: $e');
        if (attempt == _maxConnectAttempts) {
          _status.add(NotificationConnectionStatus.error);
          return;
        }
        // Linear backoff: 2s, 4s, 6s, 8s.
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
  }

  static bool _signalrLoggingConfigured = false;
  void _setupSignalrLogging() {
    if (_signalrLoggingConfigured) return;
    _signalrLoggingConfigured = true;
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((r) {
      // ignore: avoid_print
      print('[SignalR] ${r.level.name} ${r.loggerName}: ${r.message}');
    });
  }

  @override
  void retry() {
    initialize();
  }

  @override
  void dismissNotification(APINotification notification) {
    connection?.invoke("DismissNotification", args: [notification.id]);

    _stream.add(
        _stream.value.where((element) => element != notification).toList());
  }

  @override
  Stream<List<APINotification>> get notificationsStream => _stream;

  @override
  Stream<NotificationConnectionStatus> get connectionStatus => _status;

  @override
  Future disconnect() async {
    _intentionalClose = true;
    try {
      if (connection != null) {
        await connection!.stop();
      }
    } finally {
      connection = null;
      _intentionalClose = false;
    }
  }
}
