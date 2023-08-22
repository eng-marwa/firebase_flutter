import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:p8/page1.dart';

import 'NotificationHandler.dart';
import 'firebase_options.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print(token);
  }
  NotificationHandler.handleFgNotifications();
  FirebaseMessaging.onBackgroundMessage(_bgNotificationHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {'/': (context) => MyHomePage(), '/page1': (context) => Page1()},
    );
  }
}

Future<void> _bgNotificationHandler(RemoteMessage remoteMessage) async {
  print(remoteMessage.notification!.title);
  print(remoteMessage.notification!.body);
  NotificationHandler.showNotification(remoteMessage);
}
