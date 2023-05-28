import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_system.dart';

class ChangeThemeButton extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final theme_provider = Provider.of<Theme_Provider>(context);

    return Switch.adaptive(
      value: theme_provider.is_DarkMode,
      onChanged:(value) {
        final provider = Provider.of<Theme_Provider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}