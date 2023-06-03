import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kankei/theme/theme_system.dart';

String? mtoken = " ";
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
typedef TokenUpdateCallback = void Function(String token);

void requestPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission for Firebase: ${settings.authorizationStatus}');
}

void getToken(TokenUpdateCallback updateCallback) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    updateCallback(token);
    saveToken(token);
  }
}

void saveToken(String token) async {
  await FirebaseFirestore.instance.collection("users").doc(currentUserUid).update({
    "token": token,
  });
  print("Token saved");
}

void initInfo() {
  var androidInitialize = const AndroidInitializationSettings('@drawable/clean_logo');
  var iOSInitialize = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    try {
      if (payload != null && payload.isNotEmpty) {
        // Handle notification payload
      } else {
        // Handle notification without payload
      }
    } catch (e) {
      print(e);
    }
    return;
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('\n\n\nGot a message whilst in the foreground!');
    print('Message data: ${message.notification?.title}/${message.notification?.body}');

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dbfood',
      'dbfood',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const IOSNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifics, payload: message.data['title']);
  });
}
