import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../theme/theme_system.dart';
import 'push_notifications.dart';
import 'use_cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int messageCount = 0;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  void updateToken(String token) {
    setState(() {
      mtoken = token;
      print('User token: $token');
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    requestPermissions();
    getToken(updateToken);
    //setupMessageListener();
    initInfo(_lifecycleState);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
  }

  final List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) {

    //Dark or light theme
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;
    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      body: Chat(
        theme: is_dark ? DarkChatTheme(backgroundColor: Colors.black, primaryColor: Color(0xFFb18dd7),sendButtonIcon: Icon(Icons.send, color: Color(0xFFb18dd7))) :
        DefaultChatTheme( inputBackgroundColor: Color(0xFF726daf), primaryColor: Color(0xFFa894fc), inputTextCursorColor: Color(0xFFE1BEE7),sendButtonIcon: Icon(Icons.send, color: Color(0xFFE1BEE7))),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: types.User( id: FirebaseAuth.instance.currentUser?.uid??'Anonymous' )
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) async {

    String currentUserUid = FirebaseAuth.instance.currentUser?.uid??'Anonymous';
    String? email = await fetchInFireStore('users', currentUserUid??'', 'email').then( (fieldData){return fieldData;});

    types.User user = types.User(id: currentUserUid, firstName: email??'Anonymous');

    print('\n\n\n\n $messageCount\n');

    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: (messageCount++).toString(),
      text: message.text,
    );

    sendMessage(textMessage);

    _addMessage(textMessage);
  }


  Future<String> fetchInFireStore(String collection, String document, String field) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(collection).doc(document).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String fieldData = data[field];

    return fieldData;
  }


  void setupMessageListener() async {
    print('setupMessageListener');
    FirebaseFirestore.instance
        .collection('chats')
        .doc( await getChatID() )
        .collection('messages')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (DocumentChange change in snapshot.docChanges) {
        print('change: $change');
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> messageData = change.doc.data() as Map<String, dynamic>;

          print('messageData: $messageData');

          final message = types.TextMessage(
            author: types.User(id: messageData['author']),
            createdAt: messageData['timeStamp'],
            id: change.doc.id,
            text: messageData['text'],
          );

          print('\n\nmessage: $message');
          _addMessage(message);
        }
      }
    });
  }


}