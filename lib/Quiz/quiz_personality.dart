import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/Quiz/personality_results.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuizPersonality extends StatefulWidget {
  @override
  State<QuizPersonality> createState() => _QuizPersonalityState();
}






class _QuizPersonalityState extends State<QuizPersonality> {
  int currentQuestionIndex = 0;
  List<int> selectedOptions = List<int>.filled(10, -1);


  List<Map<String, dynamic>> questions = [
    {
      'question': 'What activity do you enjoy the most in your day?',
      'options': [
        {'option': 'Study', 'happiness': 1},
        {'option': 'Play a sport', 'happiness': 4},
        {'option': 'Read a book', 'happiness': 3},
        {'option': 'Watch a movie', 'happiness': 2},
      ],
    },
    {
      'question': 'How do you usually spend your weekends?',
      'options': [
        {'option': 'Going on outdoor adventures', 'happiness': 4},
        {'option': 'Relaxing at home', 'happiness': 1},
        {'option': 'Meeting friends and socializing', 'happiness': 3},
        {'option': 'Engaging in hobbies or creative activities', 'happiness': 2},
      ],
    },
    {
      'question': 'What type of music do you enjoy listening to?',
      'options': [
        {'option': 'Upbeat and energetic', 'happiness': 4},
        {'option': 'Relaxing and calming', 'happiness': 3},
        {'option': 'Melancholic and introspective', 'happiness': 1},
        {'option': 'Experimental and unique', 'happiness': 2},
      ],
    },
    {
      'question': 'Which type of vacation do you prefer?',
      'options': [
        {'option': 'Relaxing at a beach resort', 'happiness': 3},
        {'option': 'Exploring a new city', 'happiness': 1},
        {'option': 'Engaging in adventure activities', 'happiness': 2},
        {'option': 'Going on a nature retreat', 'happiness': 4},
      ],
    },
    {
      'question': 'How do you unwind after a long day?',
      'options': [
        {'option': 'Taking a warm bath', 'happiness': 1},
        {'option': 'Meditating or practicing mindfulness', 'happiness': 3},
        {'option': 'Listening to music or podcasts', 'happiness': 4},
        {'option': 'Engaging in a creative hobby', 'happiness': 2},
      ],
    },
    {
      'question': 'What brings you the most joy during social interactions?',
      'options': [
        {'option': 'Making others laugh', 'happiness': 4},
        {'option': 'Having deep and meaningful conversations', 'happiness': 1},
        {'option': 'Engaging in fun activities or games', 'happiness': 3},
        {'option': 'Supporting and helping others', 'happiness': 2},
      ],
    },
    {
      'question': 'What type of food do you enjoy the most?',
      'options': [
        {'option': 'Comfort food and desserts', 'happiness': 2},
        {'option': 'Spicy and flavorful dishes', 'happiness': 1},
        {'option': 'Fresh and healthy options', 'happiness': 4},
        {'option': 'Exotic and international cuisine', 'happiness': 3},
      ],
    },
    {
      'question': 'Which season of the year brings you the most happiness?',
      'options': [
        {'option': 'Spring', 'happiness': 3},
        {'option': 'Summer', 'happiness': 4},
        {'option': 'Fall', 'happiness': 2},
        {'option': 'Winter', 'happiness': 1},
      ],
    },
    {
      'question': 'How do you feel about exploring new hobbies or interests?',
      'options': [
        {'option': 'Excited and curious', 'happiness': 4},
        {'option': 'Open-minded and willing to try new things', 'happiness': 3},
        {'option': 'Indifferent or unsure', 'happiness': 2},
        {'option': 'Prefer sticking to familiar activities', 'happiness': 1},
      ],
    },
    {
      'question': 'What role does gratitude play in your life?',
      'options': [
        {'option': 'Practicing gratitude daily', 'happiness': 4},
        {'option': 'Recognizing and appreciating small things', 'happiness': 3},
        {'option': 'Occasional gratitude when something significant happens', 'happiness': 2},
        {'option': 'Not actively practicing gratitude', 'happiness': 1},
      ],
    },
  ];


  void selectOption(int optionIndex) {
    setState(() {
      selectedOptions[currentQuestionIndex] = optionIndex;
    });
  }



  void goToNextQuestion() {
    if (selectedOptions[currentQuestionIndex] != -1) {
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          // Quiz completed, calculate the score
          showResult();
        }
      });
    } else {
      // Show a message to the user to select an option before proceeding
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select an option'),
          content: Text('Please select an option before proceeding.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void showResult() {
    int totalHappiness = 0;
    for (int i = 0; i < selectedOptions.length; i++) {
      int selectedOptionIndex = selectedOptions[i];
      if (selectedOptionIndex != -1) {
        int happiness =
        questions[i]['options'][selectedOptionIndex]['happiness'];
        totalHappiness += happiness;
      }
    }
    int maxPossibleHappiness = questions.length * 4; // Assuming max happiness value is 4 for each question
    double scorePercentage = (totalHappiness / maxPossibleHappiness) * 100;
    int score = scorePercentage.round();
    currentQuestionIndex = 0;
    selectedOptions = List<int>.filled(10, -1); // Reset selected options
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalityResultsPage(score: score), // Call the PersonalityResultsPage with the score parameter
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = themeProvider.is_DarkMode;

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool isDark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.favorite,
          color: isDark ? Colors.white : Colors.black,
        ),
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.dark_appbar_header
            : AppColors.light_appbar_header,
        title: Text(
          'General Knowledge Quiz',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              letterSpacing: .5,
            ),
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
                questions.isNotEmpty ? questions[currentQuestionIndex]['question'] : '',
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
                  itemCount: questions.isNotEmpty ? questions[currentQuestionIndex]['options'].length : 0,
                  itemBuilder: (context, index) {
                    String option =
                        questions[currentQuestionIndex]['options'][index]['option'];
                    bool isSelected =
                        selectedOptions[currentQuestionIndex] == index;
                    Color buttonColor = isSelected
                        ? (isDark
                            ? AppColors.dark_Ideas
                            : Colors.pink.shade100)
                        : (isDark
                            ? Colors.black
                            : AppColors.light_Ideas);
                    Color textColor = isDark ? Colors.white : Colors.black;


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => selectOption(index),
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: goToNextQuestion,
              style: ElevatedButton.styleFrom(
                primary: isDark
                    ? AppColors.dark_Ideas
                    : AppColors.light_Ideas,
                elevation: 5,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


