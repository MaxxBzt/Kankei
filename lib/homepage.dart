import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import '../Game/MatchingCards.dart';
import 'app_colors.dart';
import 'countdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String SharedPhotoUrl = '';
  bool _hasPlayedFromFirestore = false;
  bool _PairedHasPlayed = false;
  var _CurrentUserScore = 0;
  var _PairedUserScore = -1;
  bool _hasCurrentWon = false;
  bool _hasPairedWon = false;

  @override
  void initState() {
    super.initState();
    fetchPicture();
    getHasPlayedFromFirestore();
    HasPairedUserPlay();
    getCurrentData();
    getPairedData();
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
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
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

  void showGamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchingCardGame()),
    ).then((value) {
    });
  }


  // Define a new function to retrieve the value of the has_played field from Firestore
  void getHasPlayedFromFirestore() async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserUid).collection('daily_game').where('has_played', isEqualTo: true).get();
    bool hasPlayed = false;
    if (querySnapshot.docs.isNotEmpty) {
      hasPlayed = querySnapshot.docs.first.data()['has_played'] ?? false;
    }
    setState(() {
      _hasPlayedFromFirestore = hasPlayed;
    });
  }



  void HasPairedUserPlay() async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;


    DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
    String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');


    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(linkedUserUid)
        .collection('daily_game')
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _PairedHasPlayed = true;
      });
    } else {
      setState(() {
        _PairedHasPlayed = false;
      });
    }
  }

  void getCurrentData() async {
    try {

      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;


      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('daily_game')
          .where('has_played', isEqualTo: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = querySnapshot.docs.first;
        String documentId = userSnapshot.id;
        int currentScore = userSnapshot.data()?['score'] ?? 0;
        bool hasWon = userSnapshot.data()?['has_won'] ?? false;


        setState(() {
          _CurrentUserScore = currentScore;
          _hasCurrentWon = hasWon;
        });
      }
    } catch (e) {
      print('Error retrieving current daily score: $e');
    }
  }



  void getPairedData() async {
    try {
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;


      DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
      String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(linkedUserUid)
          .collection('daily_game')
          .where('has_played', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = querySnapshot.docs.first;
        String documentId = userSnapshot.id;
        int pairedScore = userSnapshot.data()?['score'] ?? 0;
        bool hasWon = userSnapshot.data()?['has_won'] ?? false;


        setState(() {
          _PairedUserScore = pairedScore;
          _hasPairedWon = hasWon;
        });
      }
    } catch (e) {
      print('Error retrieving paired daily score: $e');
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              Countdown(),
// If both user didn't play the daily game
              if (!_hasPlayedFromFirestore)
                Container(
                  decoration: BoxDecoration(
                    color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 90,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Play the Daily Game',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
              SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (Platform.isIOS) {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: const Text('Play Once'),
                                content: const Text("You won't be able to play this game again for today. Do you still wish to play ? Also, by playing, you're notifying your partner that you played the game."),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () async {
                                      Navigator.pop(context); // Close the dialog
                                      // SEND NOTIFICATIONS TO PARTNER
                                      showGamePage(); // Navigate to the game page
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Play Game Only Once'),
                                content: const Text("You won't be able to play this game again for today. Do you still wish to play ? Also, by playing, you're notifying your partner that you played the game."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context); // Close the dialog
                                      // SEND NOTIFICATIONS TO PARTNER
                                      showGamePage(); // Navigate to the game page
                                    },
                                    child: const Text('Yes'),
                                  ),
                ],
                              ),
                            );
                          }
                        },
                        child: Text('Play'),
                      ),
                    ],
                  ),
                )
              // If the current user played the game, but the other no
              else if(_hasPlayedFromFirestore && !_PairedHasPlayed)
                Container(
                  decoration: BoxDecoration(
                    color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 130,
                  width: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Come tomorrow to see our new daily game!',
                textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
              ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        ),
                        onPressed: () {
                          // SEND NOTIFICATION TO PARTNER
                        },
                        child: Text('Invite your partner to play'),
                      ),
                    ],
                  ),
                )
              // If the current has played the game, and the other as well
              else
              Container(
                  decoration: BoxDecoration(
                    color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 200,
                  width: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Daily Game Results',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                          child: Text(
                            'Your score: $_CurrentUserScore',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                      Center(
                        child: Text(
                          'Your Partner: $_PairedUserScore',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),),
                      SizedBox(height: 15),
                      if (_hasCurrentWon && !_hasPairedWon)
                        Center(
                          child: Text(
                            'Your partner lost the game, you won! Congrats',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),),
                      if ((_CurrentUserScore < _PairedUserScore && _hasCurrentWon && _hasPairedWon) || (_CurrentUserScore < _PairedUserScore && !_hasCurrentWon && !_hasPairedWon))
                        Center(
                          child: Text(
                            'You won the game with less attempts than your partner, congrats!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),),
                      if (!_hasCurrentWon && _hasPairedWon)
                        Center(
                          child: Text(
                            'You lost against your partner. Bummer!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),),
                      if ((_CurrentUserScore > _PairedUserScore && _hasCurrentWon && _hasPairedWon) || (_CurrentUserScore > _PairedUserScore && !_hasCurrentWon && !_hasPairedWon))
                        Center(
                          child: Text(
                            'Your partner did less attempts than you did in the game. You lose!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if ( (_CurrentUserScore == _PairedUserScore && _hasCurrentWon && _hasPairedWon) || (_CurrentUserScore == _PairedUserScore && !_hasCurrentWon && !_hasPairedWon))
                        Center(
                          child: Text(
                            'You came in a tie! Settle it with tomorrow\'s game',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  ),
                ),
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

              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 110,
                width: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Have a date soon? Why not get inspired!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the DateIdeas page
                        Navigator.pushNamed(context, '/DateIdeas');
                      },
                      child: Text('Get An Idea'),
                    ),
                  ],
                ),
              ),

              SizedBox(height : 20.0),
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
                        'Enjoying Kankei?\nLet your friends enjoy it too!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: Share_App,

                      child: Text('Share'),
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

  void Share_App(){
    String share_message = "Hey!\nI discovered this great app that allows you to manage your relationships.\nSomething tells me you might want to check it out.\nClick here for more : https://github.com/MaxxBzt/Kankei";

    // To share via email
    Share.share(share_message, subject: "Discover the benefits of Kankei today!");

    // The apps available for the user to share will depend on which apps he has on their phone!
  }
}





