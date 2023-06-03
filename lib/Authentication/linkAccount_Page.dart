import 'package:flutter/cupertino.dart';
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
      backgroundColor: is_dark ? Color(0xFF524e85) : Color(0xFFEAE7FA),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Pair your account',
                  style: TextStyle(
                    color: is_dark ? Colors.white : Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: Text(
                  'Enter the email address of the account you want to pair with',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: is_dark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),

              const SizedBox(height: 50),

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

              const SizedBox(height: 20),

              // Link Account button
              ElevatedButton.icon(
                onPressed: linkAccount,
                icon: Icon(Icons.link),
                label: Text("Link Account"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  foregroundColor: is_dark ? Colors.black : Colors.white,
                  backgroundColor: is_dark ? Color(0xFFf0d4ec) : Color(0xFFb087bf),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text("Why linking?"),
                        content: Text(
                          'By linking your account with your partner, you will be able to see your partner\'s score for quiz, chat with them and many more.',
                          style: TextStyle(
                            color: is_dark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: is_dark ? Colors.white : Colors.black,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Why do I need to link my account?",
                      style: TextStyle(
                        color: is_dark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
