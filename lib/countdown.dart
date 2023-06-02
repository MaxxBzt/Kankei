import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';

import 'app_colors.dart';

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  List<DateTime> _targetDates = [
    DateTime(2024, 2, 14, 0, 0, 0), // Valentine's Day
    DateTime(2023, 7, 30, 0, 0, 0), // International Friendship Day
  ];
  List<String> _eventNames = [
    "Valentine's Day",
    "Friendship Day",
  ];
  int _currentPage = 0;
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime =
            _targetDates[_currentPage].difference(DateTime.now());
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .2,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 32),
          decoration: BoxDecoration(
            color: is_dark
                ? AppColors.dark_appbar_header
                : Colors.purple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(16),
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
  }
}