import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_system.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'onboarding.dart';
import 'Calendar_Page/calendar_page.dart';
import 'chat.dart';
import 'us.dart';
import 'ideas.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';


import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/date_symbol_data_local.dart';

import 'Calendar_Page/add_event_page.dart';
import 'homepage.dart';
import 'onboarding.dart';
import 'Calendar_Page/calendar_page.dart';
import 'chat.dart';
import 'inspiration.dart';
import 'us.dart';
import 'ideas.dart';
import 'package:kankei/Inspirations/show.dart';
import 'package:kankei/Inspirations/recipes.dart';
import 'date_details.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => Theme_Provider(),
    builder: (context,_)
  {
    final theme_provider = Provider.of<Theme_Provider>(context);
      return MaterialApp(
        title: 'Kankei',
        // Use the system's preferred theme if useSystemTheme is true,
        // otherwise use the selected theme
        themeMode: theme_provider.useSystemTheme
        ? ThemeMode.system
        : theme_provider.theme_mode,
        theme: MyThemes.light_theme,
        darkTheme: MyThemes.dark_theme,
        routes: {
          '/home': (context) => HomePage(),
          '/DateIdeas': (context) => DateIdeas(),
          '/chat': (context) => ChatPage(),
          '/show': (context) => PopularMoviesAndShows(),
          '/Recipe': (context) => Recipe(),
          '/DateDetailsShow' : (context) => DateDetails(activity: activities[0]),
          '/DateDetailsRecipe' : (context) => DateDetails(activity: activities[1]),
        },
        home: OnBoardingPage(),
      );
    },
  );
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
    CalendarScreen(
      key: UniqueKey(),
      color_category: Colors.red,
    ),
    ChatPage(),
    Ideas(),
    UsPage(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
