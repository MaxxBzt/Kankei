import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';
/* TOOLS */
const Color background = Color(0xFFeae7fa);
const Color lovers_box_color = Color(0xFF8e6ba0);
const Color friends_box_color = Color(0xFF54b3f5);
const Color family_box_color = Color(0xFF9e9d9c);

class ChoosePage extends StatefulWidget{
  const ChoosePage({Key? key}): super(key: key);

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {

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
                  color: background,
                  // Add a child column widget to the container
                  child: Column(
                    children:
                    [
                      SizedBox(height: 50.0),
                      Image(image: AssetImage('assets/images/kankei_title.png')),
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
                                color: Colors.black,
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
                          color: lovers_box_color,
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
                          color: friends_box_color,
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
                          color: family_box_color,
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
