import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/theme_system.dart';


class LinkAccountPage extends StatefulWidget {
  @override
  _LinkAccountPageState createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  final TextEditingController emailController = TextEditingController();

  void linkAccount() async {

    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    String? email = emailController.text.trim();

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

          // Check if the linked user is already paired with someone
          if (userSnapshot.data()?.containsKey('LinkedAccountUID') ?? false) {
            wrongEmailMessage('The user you want to get paired with is already taken');
            return;
          }

          // Check if the linked user exists in the database
          if (!userSnapshot.exists) {
            wrongEmailMessage('The user you want to pair with does not exist');
            return;
          }

          // Check if the linked user is the current user
          if (linkedUserUid == currentUserUid) {
            wrongEmailMessage('You cannot pair with yourself');
            return;
          }

          // Update the current user's document with the linked user's UID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserUid)
              .update({'LinkedAccountUID': linkedUserUid});

          // Update the linked user's document with the current user's UID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(linkedUserUid)
              .update({'LinkedAccountUID': currentUserUid});

          // Account linked successfully, perform any additional actions
          // or navigate to a new screen if needed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
          print('Account linked successfully');
        } else {
          wrongEmailMessage('No user found with the provided email address');
        }
      } catch (error) {
        print('Error linking account: $error');
        wrongEmailMessage('Error linking account');
      }
    } else {
      wrongEmailMessage('Invalid email or current user');
    }
  }

  void wrongEmailMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF726daf),
          title: Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
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
          child: SingleChildScrollView(
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
      ),
    );
  }
}
