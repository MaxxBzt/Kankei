import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:kankei/us_settings.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'Authentication/auth_page.dart';
import 'app_colors.dart';




class UsProfilePage extends StatefulWidget {
  @override
  _UsProfilePageState createState() => _UsProfilePageState();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

void confirmLogout(BuildContext context) {
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
            onPressed: () {
              // User confirms the action
              Navigator.of(context).pop(true);
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed == true) {
      signUserOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    }
  });
}

class _UsProfilePageState extends State<UsProfilePage> {
  String currentUserEmail = '';
  String linkedUserEmail = '';
  String profilePictureUrl = '';
  String linkedPictureUrl = '';

  Future<String?> uploadProfilePicture() async {
    try {
      // Use image_picker to allow the user to choose a picture from their gallery
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        // User canceled image selection
        return null;
      }

      // Create a reference to the location where you want to upload the file in Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      final File file = File(pickedFile.path);
      final UploadTask uploadTask = storageReference.putFile(file);

      // Get the download URL of the uploaded file
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the Firestore document with the download URL
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({'profilePictureUrl': downloadUrl});



      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }


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
      Map<String, dynamic> data =
          currentUserSnapshot.data() as Map<String, dynamic>;
      String currentUserEmail = data['email'] as String;
      String? currentUserProfilePictureUrl =
          data['profilePictureUrl'] as String?;

      setState(() {
        this.currentUserEmail = currentUserEmail;
        this.profilePictureUrl = currentUserProfilePictureUrl ?? '';
      });

      String linkedUserUID = data['LinkedAccountUID'] as String;

      DocumentSnapshot linkedUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(linkedUserUID)
          .get();

      if (linkedUserSnapshot.exists) {
        Map<String, dynamic> linkedUserData =
            linkedUserSnapshot.data() as Map<String, dynamic>;
        String linkedUserEmail = linkedUserData['email'] as String;
        String? linkedUserProfilePictureUrl =
            linkedUserData['profilePictureUrl'] as String?;

        setState(() {
          this.linkedUserEmail = linkedUserEmail;
          this.linkedPictureUrl = linkedUserProfilePictureUrl != null
              ? linkedUserProfilePictureUrl
              : ''; // Use a conditional expression to check for null
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
      body: Stack(
        children: [
          Container(
              // Main body content
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
          Positioned(
            top: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 80.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              children: [
                Row(
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
                        GestureDetector(
                          onTap: () async {
                            String? imageUrl = await uploadProfilePicture();
                            if (imageUrl != null) {
                              setState(() {
                                profilePictureUrl = imageUrl;
                              });
                              fetchUserEmails(); // Reload user information after changing the picture
                            }
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            foregroundImage: profilePictureUrl.isNotEmpty
                                ? NetworkImage(profilePictureUrl)
                                : null,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          currentUserEmail ?? '',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '&',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
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
                          linkedUserEmail ?? '',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

