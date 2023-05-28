import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;


  const AdaptiveSwitch({
    required Key key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    )
        : Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
