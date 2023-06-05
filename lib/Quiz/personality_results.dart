import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/ideas.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../countdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:kankei/Chat/chat.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


class PersonalityResultsPage extends StatelessWidget {
  final int score;

  PersonalityResultsPage({required this.score});

  Future<Map<String, dynamic>> getUserData() async {
    // Get the current user's UID
    if (_auth.currentUser == null) {
      return {'score': -1, 'paragraph': "waiting...", };
    }

    String currentUserUID = _auth.currentUser!.uid;

    // Reference to the current user's document
    DocumentReference userRef = _firestore.collection('users').doc(currentUserUID);

    // Check if the quiz collection exists in the user's document
    bool quizCollectionExists = false;

    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      quizCollectionExists = userData != null && userData.containsKey('quiz');
    }

    // Define quizCollectionRef
    CollectionReference quizCollectionRef = userRef.collection('quiz');

    // Delete all existing documents in the quiz collection if it exists
    if (!quizCollectionExists) {
      QuerySnapshot quizSnapshot = await quizCollectionRef.get();
      for (DocumentSnapshot docSnapshot in quizSnapshot.docs) {
        await docSnapshot.reference.delete();
      }
    }

    // Create a new document in the quiz collection with the score, time, and linked user's UID
    DocumentReference quizDocRef = quizCollectionRef.doc();

    String linkedAccountUID = userSnapshot['LinkedAccountUID'];

    await quizDocRef.set({
      'score': score, // Replace with the actual score value
      'paragraph': Paragraphs[Paragraph()], // Replace with the actual paragraph value
      'time': DateTime.now(), // Replace with the actual time value
      'linkedUID': linkedAccountUID,
    });

    return await getPartnerScore(linkedAccountUID);
  }

  Future<Map<String, dynamic>> getPartnerScore(String partnerUID) async {
    // Reference to the partner's document
    DocumentReference partnerRef = _firestore.collection('users').doc(partnerUID);


    // Get the partner's quiz document
    QuerySnapshot quizSnapshot = await partnerRef.collection('quiz').get();

    if (quizSnapshot.docs.isNotEmpty) {
      // Retrieve the latest quiz document
      QueryDocumentSnapshot latestQuizDoc = quizSnapshot.docs.last;

      // Retrieve the score and paragraph
      int partnerScore = latestQuizDoc['score'];
      String partnerParagraph = latestQuizDoc['paragraph'];


      // Return the score and paragraph as a Map
      return {
        'score': partnerScore,
        'paragraph': partnerParagraph,

      };
    } else {
      // Return null if the partner's quiz document doesn't exist yet
      return {
        'score': -1,
        'paragraph': "waiting...",

      };
    }
  }





  List<String> Paragraphs = [
    "You may be feeling quite low and dissatisfied. "
        "You may find it challenging to experience joy or find fulfillment in yout daily activities. "
        "There is a sense of emptiness and a lack of enthusiasm for life. It's important for you to explore the "
        "factors that contribute to your happiness and take steps to improve your overall well-being.",

    "You might experience occasional moments of contentment but still feel a general sense of dissatisfaction. "
        "You may have some areas of your life that bring you joy, but overall, there is room for improvement. "
        "It's essential for you to focus on identifying the aspects of life that truly make youhappy and actively incorporate more "
        "of those elements into yout daily routine.",

    "You have a moderate sense of well-being. You feel reasonably content and satisfied with your life, "
        "finding joy in various aspects of your daily activities. While there may be room for improvement in certain areas, "
        "you generally experience a sense of balance and fulfillment. You have a positive outlook and are open to new experiences "
        "that can further enhance your happiness.",

    "You are likely to feel genuinely happy and fulfilled. "
        "You find joy in many areas of your life and have a positive perspective overall. "
        "Your happiness is contagious, and you radiate a sense of positivity to those around you. "
        "You are resilient in the face of challenges and have developed coping mechanisms to maintain your high level of happiness. "
        "Life feels vibrant and exciting, and you appreciate the little things that bring you joy.",

    "You have the epitome of happiness and contentment. "
        "You feel an immense sense of joy and fulfillment in every aspect of your life. You have a deep appreciation for the present moment "
        "and approach life with gratitude and enthusiasm. You have cultivated a strong sense of purpose and meaning, "
        "which contributes to your overall happiness. "
        "Your positive energy is palpable, and you inspire others with your infectious happiness."

  ];








  int Paragraph() {
    if (score <= 20) {
      return 0;
    }
    else if ( score > 20 && score <= 40 ) {
      return 1;
    }
    else if (score > 40 && score <= 60) {
      return 2;
    }
    else if (score > 60 && score <= 80) {
      return 3;
    }
    else {
      return 4;
    }
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = themeProvider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, show a loading indicator
          return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
              elevation: 0,
              backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
              title: Text(
                'Personality Test',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // If an error occurred while fetching the data, display an error message
          return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
              elevation: 0,
              backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
              title: Text(
                'Personality Test',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
                ),
              ),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Data has been fetched successfully
          if (snapshot.data != null) {
            int partnerScore = snapshot.data!['score'];
            String partnerScoreString = partnerScore.toString();
            String partnerParagraph = snapshot.data!['paragraph'];
            String happinessMessage = '';
            if (score > partnerScore && partnerScore != -1) {
              happinessMessage = 'You are happier than your partner!';
            } else if (score < partnerScore && partnerScore != -1 ) {
              happinessMessage = 'Your partner is happier than you!';
            } else if (score == partnerScore && partnerScore != -1){
              happinessMessage = 'You and your partner are equally happy!';
            }else{
              happinessMessage = 'Waiting...';
              partnerScoreString = "Waiting...";

            }
            return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
                elevation: 0,
                backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
                title: Text(
                  'Personality Test',
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'You have reached $score % happiness! ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gill Sans',
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                        ),
                        child: Text(
                          Paragraphs[Paragraph()],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gill Sans',
                            color: is_dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },

                        style: ElevatedButton.styleFrom(
                          primary: is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                        ),
                        child: Text(
                          'Leave the Quiz',
                          style: TextStyle(
                            fontSize: 32,
                            color: is_dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your partner got $partnerScoreString % happiness! ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gill Sans',
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: is_dark ? AppColors.light_Ideas : AppColors.dark_Ideas,
                        ),
                        child: Text(
                          partnerParagraph,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gill Sans',
                            color: is_dark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      Text(
                        '$happinessMessage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gill Sans',
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );                        },

                        style: ElevatedButton.styleFrom(
                          primary: is_dark ? AppColors.light_Ideas : AppColors.dark_Ideas,
                        ),
                        child: Text(
                          'Tell them',
                          style: TextStyle(
                            fontSize: 25,
                            color: is_dark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // No data available (partner's quiz document doesn't exist yet)
            return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
                elevation: 0,
                backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
                title: Text(
                  'Personality Test',
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
                  ),
                ),
              ),
              body: Center(
                child: Text('Partner Data Not Available'),
              ),
            );
          }
        }
      },
    );
  }


}
