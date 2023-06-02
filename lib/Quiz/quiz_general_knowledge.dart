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

class QuizGeneralKnowledge extends StatefulWidget {
  @override
  State<QuizGeneralKnowledge> createState() => _QuizGeneralKnowledgeState();
}

class _QuizGeneralKnowledgeState extends State<QuizGeneralKnowledge> {
  int currentQuestionIndex = 0;
  int score = 0;

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
      'options': ['Michelangelo', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci' ],
      'correctAnswer': 'Leonardo da Vinci',
    },
    {
      'question': 'What is the largest ocean in the world?',
      'options': ['Atlantic Ocean',  'Pacific Ocean', 'Indian Ocean', 'Arctic Ocean'],
      'correctAnswer': 'Pacific Ocean',
    },
    {
      'question': 'What is the currency of Japan?',
      'options': ['Dollar', 'Euro', 'Yen' , 'Pound'],
      'correctAnswer': 'Yen',
    },
    {
      'question': 'Who wrote the play "Romeo and Juliet"?',
      'options': ['William Shakespeare', 'George Bernard Shaw', 'Anton Chekhov', 'Arthur Miller'],
      'correctAnswer': 'William Shakespeare',
    },
    {
      'question': 'Which country is famous for the Taj Mahal?',
      'options': ['Egypt', 'China',  'India', 'Brazil'],
      'correctAnswer': 'India',
    },
    {
      'question': 'What is the largest continent in the world?',
      'options': ['Asia', 'Africa', 'North America', 'Europe'],
      'correctAnswer': 'Asia',
    },
    {
      'question': 'Who was the first person to step on the moon?',
      'options': ['Alan Shepard' , 'Buzz Aldrin', 'Yuri Gagarin', 'Neil Armstrong'],
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
    },


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
    Future.delayed(Duration(seconds: 2), goToNextQuestion);
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
        showResult();
      }
    });
  }

  void showResult() {
    if (Platform.isIOS) {
      // Show CupertinoAlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {

          return CupertinoAlertDialog(
            title: const Text('Quiz Completed'),
            content: Text('Your score: $score / ${questions.length}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context, 'result');
                  MaterialPageRoute(builder: (context) => Ideas());
                },
              ),
            ],
          );
        },
        ).then((result) {
        if (result == 'result') {
          setState(() {
            score = 0;
          });
          Navigator.pop(context);
        }
      });;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Completed'),
            content: Text('Your score: $score / ${questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'result');
                  MaterialPageRoute(builder: (context) => Ideas());

                },
                child: Text('Close'),

              ),
            ],
          );
        },
      ).then((result) {
        if (result == 'result') {
          setState(() {
            score = 0;
          });
          Navigator.pop(context);
        }
      });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Center(
              child: Text(
                questions[currentQuestionIndex]['question'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive',
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
                    String option =
                    questions[currentQuestionIndex]['options'][index];
                    bool isCorrect =
                        option == questions[currentQuestionIndex]['correctAnswer'];
                    bool isSelected =
                        option == questions[currentQuestionIndex]['answerStatus'];
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
                              fontFamily: 'Cursive',
                            ),
                          ),
                      )
                      // For ANDROID
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cursive',
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
      ),
    );
  }
}