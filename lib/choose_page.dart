import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';

import 'Authentication/isLinked.dart';
import 'app_colors.dart';
import 'main.dart';
/* TOOLS */


class ChoosePage extends StatefulWidget{
  const ChoosePage({Key? key}): super(key: key);

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(

      body: Stack(
        children:
        [
          PageView(
            children:
            [
              Container
                (
                  padding: const EdgeInsets.all(30),
                  // Add a background color to the container
                  color: is_dark ? AppColors.dark_background: AppColors.light_background_choose_page,
                  // Add a child column widget to the container
                  child: Column(
                    children:
                    [
                      SizedBox(height: 50.0),
                      Container(
                        decoration: BoxDecoration(
                          color: is_dark ? Colors.white : AppColors.light_background_choose_page,
                          borderRadius: BorderRadius.circular(70.0),
                        ),
                        child: Image(image: AssetImage('assets/images/kankei_title.png')),
                      ),

                      SizedBox(height: 50.0),
                      Column(
                        children: [

                          Text(
                            'Which relationship interface do you want to access ?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: is_dark ? Colors.white : Colors.black ,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.0),
                      // Lovers Box
                      Container(
                        width: 300.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: is_dark ? AppColors.dark_lovers_box_color :AppColors.light_lovers_box_color,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context){
                                  return isLinked();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Lovers 💞',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      // Friends Box
                      Container(
                        width: 300.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: is_dark ? AppColors.dark_friends_box_color : AppColors.light_friends_box_color,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context){
                                  return MainPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Friends 🤝',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      // Family Box
                      Container(
                        width: 300.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: is_dark ? AppColors.dark_family_box_color:AppColors.light_family_box_color,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context){
                                  return MainPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Family 👨‍👩‍👧‍👦',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
