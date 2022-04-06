import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tspmobile/authentication_service.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/ui/pages/home_page.dart';
import 'package:tspmobile/ui/pages/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void _onOpenedNotification(RemoteMessage message) {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  if (message.data.containsKey('notification')) {
    print('message contains notification!');
    Map<String, dynamic> notification =
    jsonDecode(message.data['notification']);
    notificationsPlugin.show(
        0,
        notification['title'],
        notification['body'],
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'high_importance_channel', // id
                'High Importance Notifications',
                icon: "")));
  }
}

Future<void> _onBackgroundNotification(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  _onOpenedNotification(message);
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var loggedIn = false;
  final HttpClient _httpClient = HttpClient();
  final AuthenticationService _authenticationService = AuthenticationService();
  Map<String, String>? credentials = await _authenticationService.readCredentials();
  print(credentials);
  if(credentials!=null){
    int status = await _httpClient.authorize(credentials["username"]!, credentials["password"]!);
    if(status == 200){
      loggedIn = true;
      await FirebaseMessaging.instance.getToken();
    }else{
      await _authenticationService.deleteCredentials();
    }
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  notificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) {});

  FirebaseMessaging.onMessage.listen(_onOpenedNotification);
  FirebaseMessaging.onBackgroundMessage(_onBackgroundNotification);

  runApp(MyApp(loggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp(this.loggedIn, {Key? key}) : super(key: key);
  final bool loggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: loggedIn? const HomePage(): const LoginPage(),
    );
  }
}
