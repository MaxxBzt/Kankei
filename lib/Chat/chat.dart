import 'dart:convert';
import 'dart:math';
import '../../../theme/theme_system.dart';
import 'push_notifications.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';

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

class _ChatPageState extends State<ChatPage> {

  void updateToken(String token) {
    setState(() {
      mtoken = token;
      print('User token: $token');
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    getToken(updateToken);
    initInfo();
  }

  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

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
        user: _user,
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }
}
