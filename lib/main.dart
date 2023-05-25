import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';
import 'onboarding.dart';
import 'Calendar_Page/calendar_page.dart';
import 'chat.dart';
import 'inspiration.dart';
import 'us.dart';
import 'ideas.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor main_theme_color = MaterialColor(0xFFb087bf, <int, Color>{
    50: Color(0xFFb087bf),
    100: Color(0xFFb087bf),
    200: Color(0xFFb087bf),
    300: Color(0xFFb087bf),
    400: Color(0xFFb087bf),
    500: Color(0xFFb087bf),
    600: Color(0xFFb087bf),
    700: Color(0xFFb087bf),
    800: Color(0xFFb087bf),
    900: Color(0xFFb087bf),
  },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kankei',
      theme: ThemeData(
        primarySwatch: main_theme_color,
      ),
      home: OnBoardingPage(),
    );
  }
}


class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  @override
  _MainpageState createState() => _MainpageState();
}


class _MainpageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>
  [
    HomePage(),
    CalendarScreen(),
    ChatPage(),
    Ideas(),
    UsPage(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: Colors.black),
        elevation: 0,
        backgroundColor: const Color(0xFFEAE7FA),
        title: Text(
          'Kankei',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              haptic: true,
              rippleColor: Color(0xFFEAE7FA),
              hoverColor: Color(0xFFEAE7FA),
              gap: 8,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color(0xFFEAE7FA),

              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Planning',
                ),
                GButton(
                  icon: Icons.question_answer,
                  text: 'Chat',
                ),
                GButton(
                  icon: Icons.psychology_alt,
                  text: 'Ideas',
                ),
                GButton(
                  icon: Icons.people,
                  text: 'Us',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
