import 'package:flutter/material.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'countdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
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
                is_dark ? AppColors.dark_appbar_header : Colors.purple.shade100,
                Colors.pinkAccent,
                Colors.blue,
                Colors.yellow,
                Colors.purple.shade100,
              ],
              textAlign: TextAlign.center,
              isRepeatingAnimation: false,
            ),
            Countdown(),
            Image(image: AssetImage("assets/images/kankei_title.png"), height: 200, width: 200),

          ],
        ),
      ),
    );
  }
}





