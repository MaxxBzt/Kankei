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
    print('is_Usesystem: $_useSystemTheme');
    notifyListeners();
  }

  // Here we define the base theme of the app
  ThemeMode theme_mode = ThemeMode.light;
  bool get is_DarkMode => theme_mode == ThemeMode.dark;

  void toggleTheme(bool is_it_on){
    // If turned on: we put dark theme, if turn off, light screen
    theme_mode = is_it_on? ThemeMode.dark : ThemeMode.light;
    print('is_DarkMode: $is_DarkMode');
    // Updates our UI
    notifyListeners();
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

String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
