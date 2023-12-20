import 'package:darq/darq.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/order.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

class NotificationsManager implements INotificationsManager {
  HubConnection? connection;
  final _stream = BehaviorSubject<List<APINotification>?>.seeded(null);
  final _string = Injector.appInstance.get<IStrings>();

  void digestNotificaitons(Object notifications) {
    if ((notifications as List<dynamic>).isEmpty) {
      _stream.add([]);
      return;
    }

    var notificationFactory =
        Injector.appInstance.get<IModelFactory<APINotification>>();
    var orderFactory = Injector.appInstance.get<IModelFactory<Order>>();

    var res = notifications.map((e) {
      var notification = notificationFactory.fromJson(e);
      switch (notification.type) {
        case NotificationType.agentOrderCanceled:
          var order = orderFactory.fromJson(notification.object!);
          notification.body = _string.getNotificationMessage(
              NotificationType.agentOrderCanceled, order);
          break;
        case NotificationType.userOrderStatusChanged:
          var order = orderFactory.fromJson(notification.object!["order"]);
          var oldStatus = OrderStatus.values[notification.object!["oldStatus"]];
          notification.body = _string.getNotificationMessage(
              NotificationType.userOrderStatusChanged, order, oldStatus);
          break;
      }
      return notification;
    });

    if (_stream.hasValue) {
      _stream.add((_stream.value?.concat(res) ?? res).toList());
    }
  }

  void subscribe() async {
    final auth = Injector.appInstance.get<IAuth>();
    final status = auth.isLoggedIn();
    if (status == null) {
      return;
    } else if (status == LoginState.agent) {
      digestNotificaitons((await connection!.invoke("Subscribe",
          args: [NotificationType.agentOrderCanceled.index]))!);
    } else if (status == LoginState.user) {
      digestNotificaitons((await connection!.invoke("Subscribe",
          args: [NotificationType.userOrderStatusChanged.index]))!);
    }
  }

  @override
  Future initialize(String token) async {
    if (connection != null) {
      await disconnect();
    }
    connection = HubConnectionBuilder()
        .withUrl("https://eatmd.herokuapp.com/hub/notification",
            options: HttpConnectionOptions(
                accessTokenFactory: () => Future.value(token)))
        .withAutomaticReconnect()
        .build();

    connection!.on("OnNotificationReceived", (arguments) {
      digestNotificaitons([arguments![0]!]);
    });
    connection!.onreconnected(({connectionId}) async {
      subscribe();
    });

    while (true) {
      try {
        await connection!.start();
      } catch (_) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }
      break;
    }
    subscribe();
  }

  @override
  void dismissNotification(APINotification notification) {
    connection!.invoke("DismissNotification", args: [notification.id]);

    _stream.add(
        _stream.value!.where((element) => element != notification).toList());
  }

  @override
  Stream<List<APINotification>?> get notificationsStream => _stream;

  @override
  Future disconnect() async {
    try {
      if (connection != null) {
        await connection!.stop();
      }
    } finally {
      connection = null;
    }
  }
}
