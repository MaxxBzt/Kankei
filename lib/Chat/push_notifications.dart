import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'use_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

String? mtoken = " "; //Device token

//Foreground notification
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
typedef TokenUpdateCallback = void Function(String token);

void getToken(TokenUpdateCallback updateCallback) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    updateCallback(token);
    saveToken(token);
  }
}

void saveToken(String token) async {
  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  await FirebaseFirestore.instance.collection("users").doc(currentUserUid).update({
    "token": token,
  });
  print("Token saved");
}

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


initInfo( AppLifecycleState _lifecycleState) {
  var androidInitialize = const AndroidInitializationSettings(
      '@drawable/clean_logo');
  var iOSInitialize = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: androidInitialize, iOS: iOSInitialize);

  flutterLocalNotificationsPlugin.initialize(
      initializationSettings, onSelectNotification: (String? payload) async {
    try {
      if (payload != null && payload.isNotEmpty) {
        // Handle notification payload
        String fetchPayload() {
          return payload.replaceAll(RegExp(r'\\'), '');
        }
      } else {
        // Handle notification without payload
      }
    } catch (e) {
      print(e);
    }
    return;
  });

  print('\n\n\n_lifeCycleState: $_lifecycleState');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
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
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const IOSNotificationDetails());

    if (_lifecycleState == AppLifecycleState.paused) { // Only notify user if he's out of the app / in background
      await flutterLocalNotificationsPlugin.show(
          0, message.notification?.title, message.notification?.body,
          platformChannelSpecifics, payload: message.data['title']
      );
    }
  });
}


void sendNotification(types.TextMessage message) async {

  String? PartnerUID=await fetchInFireStore('users', message.author.id??'', 'LinkedAccountUID').then( (fieldData){return fieldData;});
  String? partnerToken=await fetchInFireStore('users', PartnerUID??'', 'token').then( (fieldData){return fieldData;});

  try{
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAWlVax4A:APA91bHwsxMh8k9Esun4CauGsBTwzW6qznhkuxtxEao-3t-nKXjwbCL_wY9AQu0pfFYhtm4FoS_VpLBOdx4kOFNSohiDRhW-5CMkfe8OCTSc6mNH6QIEavQeQieLkEkG6YkkrqTSogiI',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',

          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': message.text, //payload
            'title': 'New Message from ${message.author.firstName}', //payload
          },
          'notification': <String, dynamic>{
            'body': message.text,
            'title': 'New Message from ${message.author.firstName}}',
            'android_channel_id': "dbfood",
          },
          'to': partnerToken,
        },
      ),
    ).then( (value) =>
        print(value.body)
    );
  }
  catch(e){
    if(kDebugMode) print(e);
  }
}

