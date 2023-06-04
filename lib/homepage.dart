import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'countdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:share_plus/share_plus.dart';
import 'Notifications/notification_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String SharedPhotoUrl = '';
  @override
  void initState() {
    super.initState();
    fetchPicture();
  }

  Future<String?> uploadSharePic() async {
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
          .child('sharedphotosUrl')
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
          .update({'sharedphotosUrl': downloadUrl});

      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (currentUserSnapshot.exists) {
        Map<String, dynamic> data =
        currentUserSnapshot.data() as Map<String, dynamic>;
        String linkedUserUID = data['LinkedAccountUID'] as String;
        if (linkedUserUID.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(linkedUserUID)
              .update({'sharedphotosUrl': downloadUrl});
        }
      }



      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<void> fetchPicture() async {
    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    if (currentUserSnapshot.exists) {
      Map<String, dynamic> data =
          currentUserSnapshot.data() as Map<String, dynamic>;
      String? SharedPhotoUrlUser = data['sharedphotosUrl'] as String?;

      setState(() {
        this.SharedPhotoUrl = SharedPhotoUrlUser ?? '';
      });


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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ColorizeAnimatedTextKit(
                repeatForever: true,
                text: ["Kankei"],
                textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cursive"),
                colors: [
                  is_dark
                      ? AppColors.dark_appbar_header
                      : Colors.purple.shade100,
                  Colors.pinkAccent,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple.shade100,
                ],
                textAlign: TextAlign.center,
                isRepeatingAnimation: false,
              ),
              Countdown(),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  print(SharedPhotoUrl);
                  String? imageUrl = await uploadSharePic();
                  if (imageUrl != null) {
                    setState(() {
                      SharedPhotoUrl = imageUrl;
                    });
                    fetchPicture(); // Reload user information after changing the picture
                  }
                },
                child: Stack(
                  children: [
                    if (SharedPhotoUrl.isNotEmpty)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            SharedPhotoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      height: SharedPhotoUrl.isNotEmpty ? 300.0 : 80.0,
                      child: Opacity(
                        opacity: SharedPhotoUrl.isNotEmpty ? 0.0 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFb087bf),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload),
                                SizedBox(width: 8.0),
                                Text(
                                  'Upload your picture here!',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: is_dark
                            ? AppColors.dark_appbar_header
                            : AppColors.planning_add_event_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        NotificationApi.showNotification(
                          title: 'Sample title',
                          body: 'It works!',
                          payload: 'work.abs',
                        );
                      },
                      child: Text('Click'),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: is_dark
                      ? AppColors.dark_Ideas
                      : Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 110,
                width: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'You like Kankei?\nMake your friends enjoy it too.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: is_dark
                            ? AppColors.dark_appbar_header
                            : AppColors.planning_add_event_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: Share_App,
                      child: Text('Share with a friend'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void Share_App() {
    String share_message =
        "I've discovered this great app that allows you to manage your relationships. "
        "I feel like this is something you might want to check out. Check its github from here: https://github.com/MaxxBzt/Kankei";

    // To share via email
    Share.share(share_message, subject: "Discover this new app : Kankei!");

    // The apps available for the user to share will depend on which apps he has on their phone!
  }
}
