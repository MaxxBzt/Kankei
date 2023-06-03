import 'package:flutter/material.dart';
import 'package:kankei/Authentication/login_widget.dart';
import 'package:kankei/Authentication/signup.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initiate login page
  bool showLoginPage = true;

  // toggle between login and sign up
  void toggleView() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onPressed: toggleView);
    } else {
      return SignUpPage(onPressed: toggleView);
    }
  }
}