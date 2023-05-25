import 'package:flutter/material.dart';
import 'package:kankei/Authentication/login_widget.dart';
import 'package:kankei/Authentication/signup.dart';

class LoginOrRegister extends StatefulWidget{
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initiate login page
  bool showLoginPage = true;

  //toogle between login and sign up
  void toogleView() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onPressed: toogleView);
    }
    else{
      return SignUpPage(onPressed: toogleView);
    }
    }
}