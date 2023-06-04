
import 'package:flutter/material.dart';
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
              SizedBox(height: 10),
              ColorizeAnimatedTextKit(
                repeatForever: true,
                text: ["Kankei"],
                textStyle:
                TextStyle(fontSize: 60, fontWeight: FontWeight.bold, fontFamily: "Cursive"),
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
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        NotificationApi
                            .showNotification(
                          title: 'Sample title',
                          body: 'It works!',
                          payload: 'work.abs',);
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
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

  void Share_App(){
    String share_message = "I've discovered this great app that allows you to manage your relationships. "
        "I feel like this is something you might want to check out. Check its github from here: https://github.com/MaxxBzt/Kankei";

    // To share via email
    Share.share(share_message, subject: "Discover this new app : Kankei!");

    // The apps available for the user to share will depend on which apps he has on their phone!
  }
}





