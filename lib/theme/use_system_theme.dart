import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_colors.dart';
import '../components/adaptative_switch.dart';
import '../theme/theme_system.dart';

class UseSystemThemeToggle extends StatelessWidget {
  final GlobalKey _switchKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool is_dark = brightnessValue == Brightness.dark;
    final theme_provider = Provider.of<Theme_Provider>(context);

    return AdaptiveSwitch(
      key: _switchKey,
      value: theme_provider.useSystemTheme,
      onChanged: (value) {
        theme_provider.toggleUseSystemTheme();
      },
      activeColor: is_dark ? AppColors.dark_appbar_header: AppColors.light_sign_in,
    );
  }
}
