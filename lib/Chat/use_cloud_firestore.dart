import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'push_notifications.dart';

final List<types.Message> _messages = [];
Future<String> fetchInFireStore(String collection, String document, String field) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(collection).doc(document).get();

  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  String fieldData = data[field];

  return fieldData;
}

Future<String> getChatID() async {
  String currentUserUid = FirebaseAuth.instance.currentUser?.uid??'Anonymous';
  String? PartnerUID=await fetchInFireStore('users', currentUserUid??'', 'LinkedAccountUID').then( (fieldData){return fieldData;});

  String? email1 = await fetchInFireStore('users', currentUserUid??'', 'email').then( (fieldData){return fieldData;})??'Anonymous';
  String? email2 = await fetchInFireStore('users', PartnerUID??'', 'email').then( (fieldData){return fieldData;})??'Anonymous';

  List<String> emails = [email1, email2];
  emails.sort();
  return '${emails[0]}_${emails[1]}';
}

void sendMessage(types.TextMessage textMessage) async {

  FirebaseFirestore.instance.collection('chats').doc( await getChatID() ).collection('messages').add(
      {
        'author': textMessage.author.firstName,
        'timeStamp': DateTime.now().millisecondsSinceEpoch,
        'id': textMessage.id,
        'text': textMessage.text,
      }
  ).then((value) {
    sendNotification(textMessage);

    print('Message sent : ${textMessage.text}');

  }).catchError((error) {
    print('Error sending message: $error');
  });
}
