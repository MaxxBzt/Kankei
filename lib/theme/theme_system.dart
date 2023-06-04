import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../app_colors.dart';



final MaterialColor light_primary_color = MaterialColor(0xFFb087bf, <int, Color>{
  50: Color(0xFFb087bf),
  100: Color(0xFFb087bf),
  200: Color(0xFFb087bf),
  300: Color(0xFFb087bf),
  400: Color(0xFFb087bf),
  500: Color(0xFFb087bf),
  600: Color(0xFFb087bf),
  700: Color(0xFFb087bf),
  800: Color(0xFFb087bf),
  900: Color(0xFFb087bf),
},
);

final MaterialColor dark_primary_color = MaterialColor(0xFFb087bf, <int, Color>{
  50: Color(0xFFb087bf),
  100: Color(0xFFb087bf),
  200: Color(0xFFb087bf),
  300: Color(0xFFb087bf),
  400: Color(0xFFb087bf),
  500: Color(0xFFb087bf),
  600: Color(0xFFb087bf),
  700: Color(0xFFb087bf),
  800: Color(0xFFb087bf),
  900: Color(0xFFb087bf),
},
);

class Theme_Provider extends ChangeNotifier {
  // Add a property to specify whether the app should use the system's preferred theme
  bool _useSystemTheme = true;
  bool get useSystemTheme => _useSystemTheme;

  void toggleUseSystemTheme() {
    _useSystemTheme = !_useSystemTheme;
    notifyListeners();
  }

  // Here we define the base theme of the app
  ThemeMode theme_mode = ThemeMode.light;
  bool get is_DarkMode => theme_mode == ThemeMode.dark;

  void toggleTheme(bool is_it_on) {
    // If turned on: we put dark theme, if turn off, light screen
    theme_mode = is_it_on ? ThemeMode.dark : ThemeMode.light;
    // Updates our UI
    notifyListeners();
  }

  void updateTheme(BuildContext context) {
    if (_useSystemTheme) {
      final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
      bool isSystemDarkMode = brightnessValue == Brightness.dark;
      theme_mode = isSystemDarkMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
}

class MyThemes {


  static final dark_theme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark_background,
    primarySwatch: dark_primary_color,
    colorScheme: ColorScheme.dark(),

  );


  static final light_theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: light_primary_color,
    colorScheme: ColorScheme.light(),

  );
}
class EventsOnCountdown{

  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  void fetchNearestEvent(List<DateTime> targetDates, List<String> eventNames) async {
    // Clear the existing event data
    targetDates.clear();
    eventNames.clear();

    try {
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);


      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('calendar_events')
          .where('date', isGreaterThanOrEqualTo: today)
          .orderBy('date')
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Check if there are events happening on today's date
        bool hasEventsToday = false;

        for (final doc in snapshot.docs) {
          final Timestamp timestamp = doc.data()['date'] as Timestamp;

          final DateTime eventDate = timestamp.toDate();

          if (eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day) {
            hasEventsToday = true;
            break;
          }
        }

        // If there are events happening on today's date, add them to the lists
        if (hasEventsToday) {
          for (final doc in snapshot.docs) {
            final Timestamp timestamp = doc.data()['date'] as Timestamp;
            final DateTime eventDate = timestamp.toDate();
            final String eventName = doc.data()['name'];

            if (eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day) {
              targetDates.add(eventDate);
              eventNames.add(eventName);
            }
          }
        } else {
          // If there are no events happening on today's date, find the nearest date to today
          DateTime nearestDate = snapshot.docs.first.data()['date'].toDate();
          for (final doc in snapshot.docs) {
            final Timestamp timestamp = doc.data()['date'] as Timestamp;
            final DateTime eventDate = timestamp.toDate();
            if (eventDate.isBefore(nearestDate)) {
              nearestDate = eventDate;
            }
          }

          // Add events happening on the nearest date to the lists
          for (final doc in snapshot.docs) {
            final Timestamp timestamp = doc.data()['date'] as Timestamp;
            final DateTime eventDate = timestamp.toDate();
            final String eventName = doc.data()['name'];

            if (eventDate == nearestDate) {
              targetDates.add(eventDate);
              eventNames.add(eventName);
            }
          }
        }
      }
    } catch (error) {
      print('Error caught while fetching event data: $error');
    }
  }


}