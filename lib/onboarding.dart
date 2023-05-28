import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Authentication/auth_page.dart';
import 'app_colors.dart';

/* TOOLS */

class OnBoardingPage extends StatefulWidget{
  const OnBoardingPage({Key? key}): super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  //define a PageController instance _< assign it to the _controller variable
  final PageController _controller = PageController(initialPage: 0);
  bool AreWeOnLastPage = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: 
        [
          PageView(
              controller: _controller,
              // Tells us what page we are, index is the page
              onPageChanged: (index){
                setState(() {
                  // If in 3, it means we are on last page
                  AreWeOnLastPage = (index == 3);
                });
              },
              children:
              [
                // FIRST PAGE
                Container
                (
                  padding: const EdgeInsets.all(30),
                // Add a background color to the container
                  color: Colors.white,
                  // Add a child column widget to the container
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                    [
                      Image(image: AssetImage('assets/images/on_boarding_images/first_page.jpeg')),
                      Column(
                        children: [
                          Text(
                            'Connect With Your Loved Ones',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Manage one special relationship easily with the app through "
                                  "communications games, topics, chat zone & fun activities to play, and more.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      Container(
                        width: 200.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55.0),
                          color: AppColors.on_boarding_dot_swipe_color,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your button press logic here
                            _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Text(
                            'Next',
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
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.purple[100]!),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ],

                  )
                ),
                // SECOND PAGE
                Container
                  (
                    padding: const EdgeInsets.all(30),
                    // Add a background color to the container
                    color: Colors.white,
                    // Add a child column widget to the container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                        Image(image: AssetImage('assets/images/on_boarding_images/second_page.jpeg')),
                        Column(
                          children: [
                            Text(
                              'Get To Know Each Other Better',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'With our fun and interactive features, '
                                    'you can ask thought-provoking questions, '
                                    'share interesting facts, and discover new things '
                                    'about the people you care about.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        Container(
                          width: 200.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55.0),
                            color: AppColors.on_boarding_second_page_color,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              'Next',
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
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              overlayColor: MaterialStateProperty.all<Color>(Colors.purple[100]!),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],

                    )
                ),
                // THIRD PAGE
                Container
                  (
                    padding: const EdgeInsets.all(30),
                    // Add a background color to the container
                    color: Colors.white,
                    // Add a child column widget to the container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                        Image(image: AssetImage('assets/images/on_boarding_images/third_page.jpeg')),
                        Column(
                          children: [
                            Text(
                              'Keep Track Of Your Most Important Dates',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Set reminders so that you never forget. You will never forget any significant dates of your relationships. '
                                    'Goodbye forgotten birthdays, anniversary, special events.'  ,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        Container(
                          width: 200.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55.0),
                            color: AppColors.on_boarding_third_page_color,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              'Next',
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
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              overlayColor: MaterialStateProperty.all<Color>(Colors.purple[100]!),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],

                    )
                ),
                // FOURTH PAGE
                Container
                  (
                    padding: const EdgeInsets.all(30),
                    // Add a background color to the container
                    color: Colors.white,
                    // Add a child column widget to the container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                        Image(image: AssetImage('assets/images/on_boarding_images/fourth_page.jpeg')),
                        Column(
                          children: [
                            Text(
                              'Deepen Your Relationships',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Text and chat about sensitive subjects and get your partner'
                                    'or friend opinions about it. Get real with them'
                                    'by communicating on subjects you would never'
                                    'think of.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        Container(
                          width: 200.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55.0),
                            color: AppColors.on_boarding_fourth_page_color,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context){
                                    return AuthPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Get Started',
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
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              overlayColor: MaterialStateProperty.all<Color>(Colors.purple[100]!),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
          ),
                /* Count is about the count of how many we have, and
                  controller is to keep track of what page we are on*/

          Container(
            alignment: Alignment(0,0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: ScrollingDotsEffect(
                      activeDotColor: AppColors.on_boarding_dot_swipe_color,
                      dotColor: Colors.deepPurple.shade100,
                      dotHeight: 15,
                      dotWidth: 15,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
