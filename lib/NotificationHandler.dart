import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static void handleFgNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print(remoteMessage.notification!.title);
      print(remoteMessage.notification!.body);
      print(remoteMessage.data);
      showNotification(remoteMessage);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      print(remoteMessage.notification!.title);
      print(remoteMessage.notification!.body);
      print(remoteMessage.data);
      showNotification(remoteMessage);
    });
  }

  static void showNotification(RemoteMessage remoteMessage) {
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    plugin.initialize(initializationSettings);
    String channelId = 'p8';
    String channelName = 'android_p8';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            priority: Priority.high,
            importance: Importance.high,
            autoCancel: true,
            ticker: 'Message received');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    plugin.show(remoteMessage.hashCode, remoteMessage.notification!.title,
        remoteMessage.notification!.body, notificationDetails);
  }
}
