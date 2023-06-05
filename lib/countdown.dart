import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';

import 'app_colors.dart';

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {

  late Timer _timer;
  List<DateTime> _targetDates = [];
  List<String> _eventNames = [];
  int _currentPage = 0;
  Duration _remainingTime = Duration.zero;


  @override
  void initState() {
    super.initState();
    _startTimer();
    EventsOnCountdown countdown = EventsOnCountdown();
    countdown.fetchNearestEvent(_targetDates, _eventNames);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_targetDates.isNotEmpty) {
          _remainingTime = _targetDates[_currentPage].difference(DateTime.now());
        } else {
          _remainingTime = Duration.zero;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    if (_targetDates.isNotEmpty) {
      // Display the countdown
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .17,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: is_dark
                  ? AppColors.dark_appbar_header
                  : Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(10),
            child: PageView.builder(
              itemCount: _targetDates.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Text(
                      _eventNames[index],
                      style: TextStyle(
                        color: is_dark ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              _remainingTime.inDays.toString(),
                              style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * .04,
                                color: is_dark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'days',
                              style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * .02,
                                color: is_dark ? Colors.purple.shade100 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              (_remainingTime.inHours % 24).toString(),
                              style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * .04,
                                color: is_dark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'hours',
                              style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.height * .02,
                                color: is_dark ? Colors.purple.shade100 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              (_remainingTime.inMinutes % 60).toString(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * .04,
                                color: is_dark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'minutes',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * .02,
                                color: is_dark ? Colors.purple.shade100 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              (_remainingTime.inSeconds % 60).toString(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * .04,
                                color: is_dark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'seconds',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * .02,
                                color: is_dark ? Colors.purple.shade100 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            decoration: BoxDecoration(
              color: is_dark ? AppColors.dark_Ideas : Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 40,
            width: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              <Widget>[
                Center(
                  child: Text(
                    'No events in your future, yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                ),
              ],
            ),
          ),
        ],
      );
    }

  }
}