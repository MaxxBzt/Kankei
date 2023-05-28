import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kankei/Inspirations/show.dart';

import 'app_colors.dart';
import 'inspiration.dart';

class DateDetails extends StatelessWidget {
  final Activity_class activity;

  DateDetails({required this.activity});
  @override
  Widget build(BuildContext context) {
  final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
  bool is_dark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
        elevation: 0,
        backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
        title: Text(
          activity.title,
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150, // set the maximum height
              width: double.infinity, // fill the available width
              child: Image.asset(
                activity.image,
                fit: BoxFit
                    .fitWidth, // fill the width while maintaining aspect ratio
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.emoji,
                    style: TextStyle(fontSize: 60.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    activity.description,
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 16.0),
                  const Text(
                    "See what to do:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            activity.widget,
          ],
        ),
      ),
    );
  }
}
