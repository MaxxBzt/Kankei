import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kankei/Authentication/LoginOrRegister.dart';


import '../choose_page.dart';
import '../main.dart';


class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ChoosePage();
          }
          else{
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
