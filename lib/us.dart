import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/change_theme_button.dart';
import '../theme/use_system_theme.dart';

class UsPage extends StatefulWidget {
  @override
  _UsPageState createState() => _UsPageState();
}

void signUserOut(){
  FirebaseAuth.instance.signOut();
}

class _UsPageState extends State<UsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF4F4F4),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Push notifications'),
                Switch(
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email notifications'),
                Switch(
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Switch Theme Mode'),
                ChangeThemeButton(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Use Your Phone's Theme"),
                UseSystemThemeToggle(),
              ],
            ),

            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                // handle turn off notifications press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                'Turn off all notifications',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 32),
            Divider(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // handle change password press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                'Change password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Here function to break up (unlink 2 accounts)
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.withOpacity(0.5)),
                  ),
                  child: Text(
                    "Break-up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                )),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 150),
            GestureDetector(
              onTap: () {
                signUserOut(); // Call the logout method from your logout class
                },
              child: Center(
                child: Text(
                  'Logout',

                  style: TextStyle(
                    color: Colors.red, // Set the text color to red
                    fontSize: 22, // Increase the font size// Add an underline to the text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
