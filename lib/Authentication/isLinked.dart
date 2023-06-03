import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../theme/theme_system.dart';
import 'LoginOrRegister.dart';
import 'linkAccount_Page.dart';

class isLinked extends StatelessWidget {
  const isLinked({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show the loading screen while checking the authentication state
          return LoadingScreen();
        }

        if (snapshot.hasData) {
          // User is authenticated
          if (currentUserUid != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(currentUserUid).get(),
              builder: (context, documentSnapshot) {
                if (documentSnapshot.connectionState == ConnectionState.waiting) {
                  // Show the loading screen while fetching the user's document
                  return LoadingScreen();
                }

                if (documentSnapshot.hasData) {
                  DocumentSnapshot snapshot = documentSnapshot.data!;

                  if (snapshot.exists) {
                    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

                    if (data != null && data.containsKey('LinkedAccountUID')) {
                      // Field 'LinkedAccountUID' exists in the document
                      return MainPage();
                    }
                  }
                }

                // Field 'LinkedAccountUID' does not exist in the document or document doesn't exist
                // Navigate to the appropriate page based on the existence of the field
                return LinkAccountPage(); // Show LinkAccountPage if 'LinkedAccountUID' doesn't exist
              },
            );
          } else {
            // currentUserUid is null, handle the case accordingly
            return LoginOrRegister();
          }
        }

        // User is not authenticated
        return LoginOrRegister();
      },
    );
  }
}



class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;
    return Scaffold(
      backgroundColor: is_dark ? Color(0xFF524e85) : Color(0xFFEAE7FA),// Adjust the background color as needed
      body: Center(
        child: CircularProgressIndicator(), // Display a loading indicator
      ),
    );
  }
}


