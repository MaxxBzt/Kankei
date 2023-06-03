import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kankei/Authentication/LoginOrRegister.dart';
import '../choose_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking the authentication state
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // User is logged in, navigate to ChoosePage
            return ChoosePage();
          } else {
            // User is not logged in, navigate to LoginOrRegister
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}

