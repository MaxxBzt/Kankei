import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../main.dart';
import '../theme/theme_system.dart';

class LinkAccountPage extends StatefulWidget {
  @override
  _LinkAccountPageState createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  final TextEditingController emailController = TextEditingController();

  void linkAccount() async {
    String? email = emailController.text.trim();
    //Global variable
    if (currentUserUid != null && email.isNotEmpty) {
      try {
        // Get the user with the provided email address
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.size > 0) {
          // Retrieve the first user with the provided email address
          DocumentSnapshot<Map<String, dynamic>> userSnapshot = querySnapshot.docs.first;

          // Get the UID of the user to link
          String linkedUserUid = userSnapshot.id;

          // Update the current user's document with the linked user's UID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserUid)
              .update({'LinkedAccountUID': linkedUserUid});

          // Account linked successfully, perform any additional actions
          // or navigate to a new screen if needed
          // ...
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
          print('Account linked successfully');
        } else {
          print('No user found with the provided email address');
        }
      } catch (error) {
        print('Error linking account: $error');
      }
    } else {
      print('Invalid email or current user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pair your account',
                style: TextStyle(
                  color: is_dark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // Email text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Link Account button
              ElevatedButton(
                onPressed: linkAccount,
                child: Text('Link Account'),
              ),

              // Add any additional widgets or UI components as needed
            ],
          ),
        ),
      ),
    );
  }
}
