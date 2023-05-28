import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_system.dart';

class UseSystemThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);

    return Switch.adaptive(
      value: theme_provider.useSystemTheme,
      onChanged: (value) {
        theme_provider.toggleUseSystemTheme();
      },
    );
  }
}
