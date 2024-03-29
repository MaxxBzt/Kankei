import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Authentication/linkAccount_Page.dart';
import 'app_colors.dart';
import 'components/adaptative_switch.dart';
import 'dart:io' show Platform;



class UsSettingsPage extends StatefulWidget {
  @override
  _UsSettingsPageState createState() => _UsSettingsPageState();
}


void confirmBreakUpAccount(BuildContext context) async {
  bool confirmBreakUp = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to break up ?\n\nIt will unlink your account with your partner\n\nThis will result in all the data you have being deleted'),
        actions: [
          TextButton(
            onPressed: () {
              // User cancels the action
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // User confirms the action
              Navigator.of(context).pop(true);
            },
            child: Text('Break up'),
          ),
        ],
      );
    },
  );

  if (confirmBreakUp == true) {
    performBreakUpAccount(context);
  }
}

void performBreakUpAccount(BuildContext context) async {
  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserUid != null) {
    try {
      // Get the current user's document
      DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserUid)
              .get();

      // Check if the current user is linked to another account
      if (currentUserSnapshot.data()?.containsKey('LinkedAccountUID') ??
          false) {
        // Get the linked user's UID
        String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');

        //Delete the events from the currentUser
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .collection('calendar_events')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            document.reference.delete();
          });
        });

        //Delete the quiz from the currentUser
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .collection('quiz')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            document.reference.delete();
          });
        });

        //Delete the events from the linkedUser
        await FirebaseFirestore.instance
            .collection('users')
            .doc(linkedUserUid)
            .collection('calendar_events')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            document.reference.delete();
          });
        });

        //Delete the quizzes from the linkedUser
        await FirebaseFirestore.instance
            .collection('users')
            .doc(linkedUserUid)
            .collection('quiz')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            document.reference.delete();
          });
        });

        // Update the current user's document to remove the "LinkedAccountUID" field
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .update({'LinkedAccountUID': FieldValue.delete()});

        // Update the linked user's document to remove the "LinkedAccountUID" field
        await FirebaseFirestore.instance
            .collection('users')
            .doc(linkedUserUid)
            .update({'LinkedAccountUID': FieldValue.delete()});

        print('Account break-up successful');

        // Navigate to the LinkAccountPage using the provided context
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LinkAccountPage()),
        );
      } else {
        AlertDialog(
          title: Text('Error'),
          content: Text('You are not linked to another account'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      }
    } catch (error) {
      AlertDialog(
        title: Text('Error'),
        content: Text('Error breaking up account: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    }
  } else {
    AlertDialog(
      title: Text('Error'),
      content: Text('Invalid current user'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class _UsSettingsPageState extends State<UsSettingsPage> {

  bool pushNotifications = true;
  bool emailNotifications = true;
  final GlobalKey _switchKey = GlobalKey();
  final GlobalKey _switchKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading:
        Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
        elevation: 0,
        backgroundColor: is_dark
            ? AppColors.dark_appbar_header
            : AppColors.light_appbar_header,
        title: Text(
          'Kankei',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
                color: is_dark ? Colors.white : Colors.black,
                letterSpacing: .5),
          ),
        ),
      ),
      //backgroundColor: Color(0xFFF4F4F4),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Push notifications'),
                AdaptiveSwitch(
                  key: _switchKey,
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                  activeColor: is_dark
                      ? AppColors.dark_appbar_header
                      : AppColors.light_sign_in,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email notifications'),
                AdaptiveSwitch(
                  key: _switchKey2,
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                  activeColor: is_dark
                      ? AppColors.dark_appbar_header
                      : AppColors.light_sign_in,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                // handle turn off notifications press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                'Turn off all notifications',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                // handle change password press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                'Change password',
                style: TextStyle(
                  fontSize: 16,
                  color: is_dark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: () {
                        confirmBreakUpAccount(context);
                      },
                      color: is_dark
                          ? AppColors.dark_appbar_header
                          : AppColors.light_sign_in,
                      child: Text(
                        "Break-up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        confirmBreakUpAccount(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            is_dark
                                ? AppColors.dark_appbar_header
                                : AppColors.light_sign_in),
                      ),
                      child: Text(
                        "Break-up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
