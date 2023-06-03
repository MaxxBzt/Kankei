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

class PersonalityResultsPage extends StatelessWidget {
  final int score;

  PersonalityResultsPage({required this.score});


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

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
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
                  color : is_dark? Colors.white : Colors.black,
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

              },
              style: ElevatedButton.styleFrom(
                primary: is_dark? AppColors.dark_Ideas : AppColors.light_Ideas, // Set the background color of the button
              ),
              child: Text(
                'Leave the Quiz',
                style: TextStyle(
                  fontSize: 32,
                  color : is_dark? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}






/*
void showResult() {
  final themeProvider = Provider.of<Theme_Provider>(context);
  bool isAppDarkMode = themeProvider.is_DarkMode;

  final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
  bool isSystemDarkMode = brightnessValue == Brightness.dark;

  bool isDark = isAppDarkMode || isSystemDarkMode;

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

  // Show the result

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You scored: $score / 100',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gill Sans',
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/ideas_images/keep-calm-your-quiz-is-finished.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentQuestionIndex = 0;
                      selectedOptions = List<int>.filled(10, -1); // Reset selected options
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isDark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                  ),
                  child: Text(
                    'Leave the Quiz',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 32,
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    },
  );
}
*/