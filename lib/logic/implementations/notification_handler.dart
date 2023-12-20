import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/main.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';

class NotificationHandler {
  final String channelId = "notification-channle";
  final String channelName = "Channle Notification";

  Future<void> _createNotificationChannel() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId, channelName,
        importance: Importance.max, enableLights: true);
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }
    await _createNotificationChannel();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,
        autoStartOnBoot: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

  Future<void> onHandlerStart(ServiceInstance service) async {
    print("Notification handler started in background");
    await _createNotificationChannel();
    await setDependencies();
    final notificationManager =
        Injector.appInstance.get<INotificationsManager>();
    final strings = Injector.appInstance.get<IStrings>();
    Injector.appInstance.get<IAuth>();
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId, channelName,
        priority: Priority.max, importance: Importance.max);

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // bring to foreground
    notificationManager.notificationsStream.listen((event) async {
      if (event != null && event.isNotEmpty) {
        for (var notification in event) {
          await notificationsPlugin.show(
              notification.id,
              strings.getNotificationTypeString(notification.type),
              notification.body,
              notificationDetails);
          notificationManager.dismissNotification(notification);
        }
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  final handler = NotificationHandler();
  await handler.onHandlerStart(service);
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  final handler = NotificationHandler();
  await handler.onHandlerStart(service);
  return true;
}
