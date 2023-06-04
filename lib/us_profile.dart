import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:kankei/us_settings.dart';
import 'package:provider/provider.dart';

import 'Authentication/auth_page.dart';
import 'app_colors.dart';



class UsProfilePage extends StatefulWidget {
  @override
  _UsProfilePageState createState() => _UsProfilePageState();
}

class _UsProfilePageState extends State<UsProfilePage> {
  String currentUserEmail = '';
  String linkedUserEmail = '';


  @override
  void initState() {
    super.initState();
    fetchUserEmails();
  }

  Future<void> fetchUserEmails() async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    if (currentUserSnapshot.exists) {
      Map<String, dynamic> data = currentUserSnapshot.data() as Map<String, dynamic>;
      String currentUserEmail = data['email'] as String;

      setState(() {
        this.currentUserEmail = currentUserEmail;
      });

      String linkedUserUID = data['LinkedAccountUID'] as String;

      DocumentSnapshot linkedUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(linkedUserUID)
          .get();

      if (linkedUserSnapshot.exists) {
        Map<String, dynamic> linkedUserData = linkedUserSnapshot.data() as Map<String, dynamic>;
        String linkedUserEmail = linkedUserData['email'] as String;

        setState(() {
          this.linkedUserEmail = linkedUserEmail;
        });
      }
    }
  }

  void confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // User cancels the action
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // User confirms the action
                Navigator.of(context).pop(true);
                await signUserOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle sign-out error if necessary
      print('Sign out error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              // Main body content
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: is_dark
                          ? AppColors.dark_Ideas
                          : Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'You',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey, // Placeholder color
                              // You can add a profile picture here later
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              currentUserEmail,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '&',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Column(
                          children: [
                            Text(
                              'Your partner',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey, // Placeholder color
                              // You can add a profile picture here later
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              linkedUserEmail,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsSettingsPage()),
                  );
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: is_dark
                        ? AppColors.dark_appbar_header
                        : AppColors.light_appbar_header,
                  ),
                  child: Icon(
                    Icons.settings,
                    color: is_dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  confirmLogout(context);
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: is_dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

