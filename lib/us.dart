import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class UsPage extends StatefulWidget {
  @override
  _UsPageState createState() => _UsPageState();
}

class _UsPageState extends State<UsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('This is the us page'),
      ),
    );
  }
}
