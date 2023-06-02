import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/theme_system.dart';
import '../Chat/send_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_textfield.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  String? mtoken = " ";

  @override
  void initState() {
    super.initState();
    requestPermissions();
    getToken();
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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) { setState(() {
              mtoken = token;
              print('User token: $token');
            });
              saveToken(token!);
            }
    );
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("UserTokens").set({
      "token": token,
    });
  }

  @override
  Widget build(BuildContext context) {

    //Light or dark theme
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;
    final Brightness brightnessValue = MediaQuery
        .of(context)
        .platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;
    bool is_dark = isAppDarkMode || isSystemDarkMode;

    List<String> chatMessages = [];
    TextEditingController _messageController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatMessages[index]),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                IconButton( // Emoji button
                  icon: Icon(CupertinoIcons.smiley),
                  onPressed: () {
                    // Handle emoji button press
                  },
                ),
                Expanded(
                  child: MyTextField( // Text input
                    controller: TextEditingController(),
                    hintText: 'Type here...',
                    obscureText: false,
                  ),
                ),
                IconButton( // Send button
                  icon: Icon(CupertinoIcons.paperplane_fill),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

