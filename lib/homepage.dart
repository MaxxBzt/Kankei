import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'countdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            ColorizeAnimatedTextKit(
              repeatForever: true,
              text: ["Kankei"],
              textStyle: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, fontFamily: "Cursive"),
              colors: [
                Colors.purple.shade100,
                Colors.pinkAccent,
                Colors.blue,
                Colors.yellow,
                Colors.purple.shade100,

              ],
              textAlign: TextAlign.center,
              isRepeatingAnimation: false,
            ),
            Countdown(),


          ],
        ),
      ),
    );
  }
}





