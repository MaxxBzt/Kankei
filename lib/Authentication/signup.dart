import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';


class SignUpPage extends StatefulWidget {
  final Function()? onPressed;
  const SignUpPage({Key? key,required this.onPressed});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // display messages
    void displayMessages(String message) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message),
              ));
    }

    if (passwordController.text != confirmPasswordController.text) {
      // pop the loading circle
      Navigator.pop(context);
      // show error to user
      displayMessages("Passwords do not match !");
      return;
    }

    //try create user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );


    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      displayMessages(error.message!);
    }
    if(context.mounted) {
      Navigator.pop(context);
      print("REGISTERED");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              const Icon(
                Icons.favorite,
                size: 50,
              ),

              const SizedBox(height: 30),

              // Ready to deepen your relationships ?
              Text(
                'Ready to deepen your relationships ?',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: ' Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // sign in button
              MyButton(
                onTap: (
                    ) {signUserUp();},
                buttonText: 'Register',
              ),

              const SizedBox(height: 50),

              const SizedBox(height: 100),

              // not a member? register now
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 350.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55.0),
                    color: AppColors.on_boarding_first_page_color,
                  ),
                  child: ElevatedButton(
                    onPressed: (widget.onPressed),
                    child: Text(
                      'Already have an account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.purple[100]!),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
