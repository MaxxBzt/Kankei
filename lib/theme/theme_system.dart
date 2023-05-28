import 'package:flutter/material.dart';
import '../../app_colors.dart';

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

  void toggleTheme(bool is_it_on){
    // If turned on: we put dark theme, if turn off, light screen
    theme_mode = is_it_on? ThemeMode.dark : ThemeMode.light;
    // Updates our UI
    notifyListeners();
  }
}
class MyThemes {

  static final dark_theme = ThemeData(
      scaffoldBackgroundColor: AppColors.dark_background,
      primaryColor: AppColors.dark_primary_color,
      colorScheme: ColorScheme.dark(),

  );


  static final light_theme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.light_primary_color,
      colorScheme: ColorScheme.light(),
  );
}