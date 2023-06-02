import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import '../theme/theme_system.dart';
import 'LoginOrRegister.dart';
import 'linkAccount_Page.dart';

class isLinked extends StatelessWidget {
  const isLinked({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is authenticate

            if (currentUserUid != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(currentUserUid).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot documentSnapshot = snapshot.data!;

                    if (documentSnapshot.exists) {
                      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

                      if (data != null && data.containsKey('LinkedAccountUID')) {
                        // Field 'isLinked' exists in the document
                        return MainPage();
                      }
                    }
                  }

                  // Field 'LinkedAccount' does not exist in the document or document doesn't exist
                  return LinkAccountPage();
                },
              );
            }
          }

          // User is not authenticated
          return LoginOrRegister();
        },
      ),
    );
  }
}
