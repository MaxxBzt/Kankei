import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateDetails extends StatelessWidget {
  final Map<String, String> activity;

  DateDetails({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            activity['title']!,
            style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
      ),
        ),
        backgroundColor: const Color(0xFFEAE7FA),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(activity['image']!),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['emoji']!,
                    style: TextStyle(fontSize: 60.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    activity['description']!,
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 16.0),
                  const Text(
                    'Links:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  // Add relevant links here, e.g.:
                  const Text('https://www.example.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
