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

class QuizGeneralKnowledge extends StatefulWidget {
  @override
  State<QuizGeneralKnowledge> createState() => _QuizGeneralKnowledgeState();
}

class _QuizGeneralKnowledgeState extends State<QuizGeneralKnowledge> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizCompleted = false;
  int partnerScore = -1;
  String partnerScoreString = "";
  String resultText = "";

  Future <int> getUserData() async {
    // Get the current user's UID
    if (_auth.currentUser == null) {
      return -1;
    }

    String currentUserUID = _auth.currentUser!.uid;

    // Reference to the current user's document
    DocumentReference userRef = _firestore.collection('users').doc(
        currentUserUID);

    // Check if the quiz collection exists in the user's document
    bool generalquizCollectionExists = false;

    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<
          String,
          dynamic>?;
      generalquizCollectionExists =
          userData != null && userData.containsKey('generalquiz');
    }

    // Define quizCollectionRef
    CollectionReference generalquizCollectionRef = userRef.collection(
        'generalquiz');

    // Delete all existing documents in the quiz collection if it exists
    if (!generalquizCollectionExists) {
      QuerySnapshot quizSnapshot = await generalquizCollectionRef.get();
      for (DocumentSnapshot docSnapshot in quizSnapshot.docs) {
        await docSnapshot.reference.delete();
      }
    }

    // Create a new document in the quiz collection with the score, time, and linked user's UID
    DocumentReference quizDocRef = generalquizCollectionRef.doc();

    String linkedAccountUID = userSnapshot['LinkedAccountUID'];

    await quizDocRef.set({
      'score': score, // Replace with the actual score value
      'linkedUID': linkedAccountUID,
    });

    return await getPartnerScore(linkedAccountUID);
  }

  Future<int> getPartnerScore(String partnerUID) async {
    // Reference to the partner's document
    DocumentReference partnerRef = _firestore.collection('users').doc(
        partnerUID);

    // Get the partner's quiz document
    QuerySnapshot quizSnapshot = await partnerRef.collection('generalquiz')
        .get();

    if (quizSnapshot.docs.isNotEmpty) {
      // Retrieve the latest quiz document
      QueryDocumentSnapshot latestQuizDoc = quizSnapshot.docs.last;

      // Retrieve the score
      int partnerScore = latestQuizDoc['score'];

      // Return the partner's score as an integer
      return partnerScore;
    } else {
      // Return null if the partner's quiz document doesn't exist yet
      return -1;
    }
  }


  List<Map<String, dynamic>> questions = [

    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Madrid', 'Rome'],
      'correctAnswer': 'Paris',
    },

    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Jupiter', 'Venus', 'Mars', 'Mercury'],
      'correctAnswer': 'Mars',
    },

    {
      'question': 'Who painted the Mona Lisa?',
      'options': [
        'Michelangelo',
        'Vincent van Gogh',
        'Pablo Picasso',
        'Leonardo da Vinci'
      ],
      'correctAnswer': 'Leonardo da Vinci',
    },
    /*
    {
      'question': 'What is the largest ocean in the world?',
      'options': [
        'Atlantic Ocean',
        'Pacific Ocean',
        'Indian Ocean',
        'Arctic Ocean'
      ],
      'correctAnswer': 'Pacific Ocean',
    },
    {
      'question': 'What is the currency of Japan?',
      'options': ['Dollar', 'Euro', 'Yen', 'Pound'],
      'correctAnswer': 'Yen',
    },
    {
      'question': 'Who wrote the play "Romeo and Juliet"?',
      'options': [
        'William Shakespeare',
        'George Bernard Shaw',
        'Anton Chekhov',
        'Arthur Miller'
      ],
      'correctAnswer': 'William Shakespeare',
    },
    {
      'question': 'Which country is famous for the Taj Mahal?',
      'options': ['Egypt', 'China', 'India', 'Brazil'],
      'correctAnswer': 'India',
    },
    {
      'question': 'What is the largest continent in the world?',
      'options': ['Asia', 'Africa', 'North America', 'Europe'],
      'correctAnswer': 'Asia',
    },
    {
      'question': 'Who was the first person to step on the moon?',
      'options': [
        'Alan Shepard',
        'Buzz Aldrin',
        'Yuri Gagarin',
        'Neil Armstrong'
      ],
      'correctAnswer': 'Neil Armstrong',
    },
    {
      'question': 'Which country is famous for the Great Wall?',
      'options': ['China', 'Italy', 'Mexico', 'Greece'],
      'correctAnswer': 'China',
    },
    {
      'question': 'who is depressed',
      'options': ['All the above', 'Yoke', 'Max', 'Quentin'],
      'correctAnswer': 'All the above',
    },*/


    // Add more questions here...
  ];

  void checkAnswer(String selectedOption) {
    String correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
    if (selectedOption == correctAnswer) {
      setState(() {
        score++;
        showCorrectAnswerFeedback(selectedOption, true);
      });
    } else {
      setState(() {
        showCorrectAnswerFeedback(selectedOption, false);
      });
    }
    Future.delayed(Duration(seconds: 1), goToNextQuestion);
  }

  void showCorrectAnswerFeedback(String selectedOption, bool isCorrect) {
    if (isCorrect) {
      questions[currentQuestionIndex]['answerStatus'] = selectedOption;
    } else {
      questions[currentQuestionIndex]['answerStatus'] = selectedOption;
      questions[currentQuestionIndex]['wrongAnswers'] =
      List<String>.from(questions[currentQuestionIndex]['options']);
      questions[currentQuestionIndex]['wrongAnswers'].remove(selectedOption);
    }
  }

  void goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Quiz completed, show the result
        quizCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery
        .of(context)
        .platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return FutureBuilder<int>(
      future: quizCompleted ? getUserData() : Future.value(-1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                  Icons.favorite, color: is_dark ? Colors.white : Colors.black),
              elevation: 0,
              backgroundColor: is_dark
                  ? AppColors.dark_appbar_header
                  : AppColors.light_appbar_header,
              title: Text(
                'General Knowledge Quiz',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                      color: is_dark ? Colors.white : Colors.black,
                      letterSpacing: .5),
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                  Icons.favorite, color: is_dark ? Colors.white : Colors.black),
              elevation: 0,
              backgroundColor: is_dark
                  ? AppColors.dark_appbar_header
                  : AppColors.light_appbar_header,
              title: Text(
                'Personality Test',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                      color: is_dark ? Colors.white : Colors.black,
                      letterSpacing: .5),
                ),
              ),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          if (snapshot.data != null) {
            if (quizCompleted) {
              partnerScore = snapshot.data!;
              if(partnerScore == -1)
                partnerScoreString = "Waiting...";
              else
                partnerScoreString = partnerScore.toString();

              if (score > partnerScore && partnerScore != -1) {
                resultText = 'Congratulations! You Won!';
              } else if (score < partnerScore && partnerScore != -1) {
                resultText = 'Sorry! You Lost!';
              } else if(score == partnerScore && partnerScore != -1) {
                resultText = 'It\'s a Tie!';
              }else{
                resultText = 'You should tell them to do the quiz!';
              }
            }

            return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.favorite,
                    color: is_dark ? Colors.white : Colors.black),
                elevation: 0,
                backgroundColor: is_dark
                    ? AppColors.dark_appbar_header
                    : AppColors.light_appbar_header,
                title: Text(
                  'General Knowledge Quiz',
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(
                        color: is_dark ? Colors.white : Colors.black,
                        letterSpacing: .5),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          questions[currentQuestionIndex]['question'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gill Sans',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 50),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: questions[currentQuestionIndex]['options']
                                .length,
                            itemBuilder: (context, index) {
                              String option = questions[currentQuestionIndex]['options'][index];
                              bool isCorrect = option ==
                                  questions[currentQuestionIndex]['correctAnswer'];
                              bool isSelected = option ==
                                  questions[currentQuestionIndex]['answerStatus'];
                              bool isWrong = isSelected && !isCorrect;
                              Color buttonColor = isWrong
                                  ? Colors.red
                                  : (isSelected ? Colors.green : (is_dark
                                  ? AppColors.dark_Ideas
                                  : AppColors.light_Ideas));

                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Platform.isIOS
                                    ? CupertinoButton(
                                  onPressed: () {
                                    checkAnswer(option);
                                  },
                                  color: buttonColor,
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isWrong ? Colors.white : (is_dark
                                          ? Colors.white
                                          : Colors.black),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gill Sans',
                                    ),
                                  ),
                                )
                                    : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: buttonColor,
                                    minimumSize: Size(200, 50),
                                  ),
                                  onPressed: () {
                                    checkAnswer(option);
                                  },
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isWrong ? Colors.white : (is_dark
                                          ? Colors.white
                                          : Colors.black),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gill Sans',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (quizCompleted)
                    Container(
                      color: is_dark ? Colors.black : Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 32),
                          Text(
                            'You scored  : $score / ${questions.length}',
                            style: TextStyle(
                              color: is_dark ? Colors.white : Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gill Sans',
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(

                            'Your partner scored  : $partnerScoreString / ${questions.length}',
                            style: TextStyle(
                              color: is_dark ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gill Sans',
                            ),
                          ),
                          Text(
                            resultText,
                            style: TextStyle(
                              color: is_dark ? Colors.white : Colors.black,
                              fontSize: 22,
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
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(), // Add the desired widget inside the ClipRRect
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                currentQuestionIndex = 0;
                                score = 0;
                                quizCompleted = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: is_dark
                                  ? AppColors.dark_Ideas
                                  : AppColors.light_Ideas,
                            ),
                            child: Text(
                              'Leave the Quiz',
                              style: TextStyle(
                                color: is_dark ? Colors.white : Colors.black,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.favorite,
                    color: is_dark ? Colors.white : Colors.black),
                elevation: 0,
                backgroundColor: is_dark
                    ? AppColors.dark_appbar_header
                    : AppColors.light_appbar_header,
                title: Text(
                  'Personality Test',
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(
                        color: is_dark ? Colors.white : Colors.black,
                        letterSpacing: .5),
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

/*
  @override
  Widget build(BuildContext context) {

    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
        elevation: 0,
        backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
        title: Text(
          'General Knowledge Quiz',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  questions[currentQuestionIndex]['question'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gill Sans',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: questions[currentQuestionIndex]['options'].length,
                    itemBuilder: (context, index) {
                      String option = questions[currentQuestionIndex]['options'][index];
                      bool isCorrect = option == questions[currentQuestionIndex]['correctAnswer'];
                      bool isSelected = option == questions[currentQuestionIndex]['answerStatus'];
                      bool isWrong = isSelected && !isCorrect;
                      Color buttonColor = isWrong
                          ? Colors.red
                          : (isSelected ? Colors.green : (is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas));

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Platform.isIOS
                            ? CupertinoButton(
                          onPressed: () {
                            checkAnswer(option);
                          },
                          color: buttonColor,
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isWrong ? Colors.white : (is_dark ? Colors.white : Colors.black),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gill Sans',
                            ),
                          ),
                        )
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            minimumSize: Size(200, 50),
                          ),
                          onPressed: () {
                            checkAnswer(option);
                          },
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isWrong ? Colors.white : (is_dark ? Colors.white : Colors.black),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gill Sans',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          if (quizCompleted)
            Container(
            partnerScore = snapshot.data!;

              color: is_dark ? Colors.black : Colors.white,
              width: double.infinity, // Set width to cover the entire screen
              height: double.infinity, // Set height to cover the entire screen
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  SizedBox(height: 32),
                  Text(
                    'You scored  : $score / ${questions.length}',
                    style: TextStyle(
                      color: is_dark? Colors.white : Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gill Sans',
                    ),
                  ),
                  SizedBox(height: 16),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                    child: Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        currentQuestionIndex = 0;
                        score = 0;
                        quizCompleted = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: is_dark? AppColors.dark_Ideas : AppColors.light_Ideas, // Set the desired button color here
                    ),
                    child: Text(
                      'Leave the Quiz',
                      style: TextStyle(
                        color: is_dark? Colors.white : Colors.black,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                ],
              ),
            ),


        ],
      ),
    );
  }
  */

