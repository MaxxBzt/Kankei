import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'main.dart';
/* TOOLS */
const Color first_purple = Color(0xFFEAE7FA);
const Color second_purple = Color(0xFFC7C0ED);
const Color third_purple = Color(0xFFD6BAE6);
const Color fourth_purple = Color(0xFFC29CD6);

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
                Container(
                  color: first_purple,
                  child: Center(child: Text('Page 1')),
                ),
                Container(
                  color: second_purple,
                  child: Center(child: Text('Page 2')),
                ),
                Container(
                  color: third_purple,
                  child: Center(child: Text('Page 3')),
                ),
                Container(
                  color: fourth_purple,
                  child: Center(child: Text('Page 4')),
                ),
              ] ,
          ),
          /* Count is about the count of how many we have, and
          controller is to keep track of what page we are on*/
          Container(
            alignment: Alignment(0,0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip
                GestureDetector(
                  onTap: (){
                    // 0 is first page, we jump to last page
                    _controller.jumpToPage(3);
                  },
                  child: Text('Skip'),
                ),

                SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.deepPurple,
                      dotColor: Colors.deepPurple.shade100,
                      dotHeight: 30,
                      dotWidth: 20,
                    )),

                // Next or Finish button: Done shown only if we are on last page
                AreWeOnLastPage
                    ? GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context){
                                  return MainPage();
                                },
                              ),
                          );
                        },
                        child: Text('Finish'),
                      )
                      // If not on Last page
                    : GestureDetector(
                        onTap: (){
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Next'),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
