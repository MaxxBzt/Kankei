import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kankei/inspiration.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailScreen extends StatefulWidget {
// In the constructor, require a prompt.
  const DetailScreen({Key? key, required this.prompt}) : super(key: key);

// Declare a field that holds the prompt.
  final String prompt;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String responseText = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final String response = await getGpt3Response();
      setState(() {
        print(response);
        responseText = response;
      });
    } catch (e) {
// Handle error
      print(e.toString());
    }
  }

  Future<String> getGpt3Response() async {
    final String apiUrl = "https://api.openai.com/v1/completions";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer API-KEY"
    };

    final Map<String, dynamic> body = {
      "model": "text-davinci-003",
      "prompt":
          " Give me some innovative date ideas for me and my partner. Maybe based on our interests? \n\nInterests: ${widget.prompt} \n\nDate ideas:",
      "temperature": 0.5,
      "max_tokens": 60,
      "top_p": 0.3,
      "frequency_penalty": 0.5,
      "presence_penalty": 0.0
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String generatedText = data['choices'][0]['text'];
      return generatedText;
    } else {
      throw Exception('Failed to get response from GPT-3 API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.favorite,
              color: is_dark ? Colors.white : Colors.black),
          elevation: 0,
          backgroundColor: is_dark
              ? AppColors.dark_appbar_header
              : AppColors.light_appbar_header,
          title: Text(
            'Kankei',
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                  color: is_dark ? Colors.white : Colors.black,
                  letterSpacing: .5),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Image(
                  image: AssetImage('assets/images/bot.png'),
                  height: 50,
                  width: 50),
              Column(
                children: responseText
                    .split('\n')
                    .map(
                      (item) => Column(
                        children: [
                          Text(
                            item.trim(),
                            style: TextStyle(
                                fontSize: 20,
                                color: is_dark ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                              height:
                                  20), // Adjust the height as per your requirement
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ));
  }
}
