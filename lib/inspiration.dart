import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:kankei/Inspirations/aiPage.dart';
import 'package:kankei/Inspirations/show.dart';
import 'package:kankei/Inspirations/recipes.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:kankei/us_profile.dart';
import 'package:kankei/us_settings.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'date_details.dart';
import 'package:kankei/Inspirations/aiPage.dart';

import 'package:animations/animations.dart';

class Activity_class {
  final String title;
  final String emoji;
  final String image;
  final String description;
  final Widget
      widget; // add a property to represent the widget that should be displayed for the activity

  const Activity_class({
    required this.title,
    required this.emoji,
    required this.image,
    required this.description,
    required this.widget,
  });
}

final List<Activity_class> activities = [
  Activity_class(
    title: 'Watch a movie',
    emoji: '🎬',
    image: 'assets/images/ideas_images/watch_movie.png',
    description: 'Enjoy a cozy movie night together at home or at a theater.',
    widget: PopularMoviesAndShows(), // set the widget for this activity
  ),
  Activity_class(
    title: 'Cook together',
    emoji: '🍳',
    image: 'assets/images/ideas_images/cooking.png',
    description:
    'Prepare a delicious meal together and have fun in the kitchen.',
    widget: Recipe(),
  ),
  Activity_class(
    title: 'Go for a hike',
    emoji: '🥾',
    image: 'assets/images/ideas_images/go_hiking.jpg',
    description:
    'Explore nature together and enjoy some fresh air on a hiking trail.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Visit an art gallery',
    emoji: '🎨',
    image: 'assets/images/ideas_images/artGallery.jpeg',
    description:
    'Discover and appreciate art together at a local gallery or museum.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Go to the beach',
    emoji: '🏖️',
    image: 'assets/images/ideas_images/beach.jpg',
    description:
    'Spend a relaxing day together at the beach and enjoy the sun and sand.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Go to a restaurant',
    emoji: '🧑‍🍳',
    image: 'assets/images/ideas_images/restaurant.jpg',
    description:
    'Enjoy a romantic dinner together at a restaurant or cafe of your choice.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Have a picnic',
    emoji: '🧺',
    image: 'assets/images/ideas_images/picnic.jpg',
    description:
    'Pack a basket with your favorite foods and enjoy a meal outdoors.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Stargazing',
    emoji: '🌠',
    image: 'assets/images/ideas_images/stargazing.jpg',
    description:
    'Find a quiet spot away from city lights and marvel at the night sky.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Play board games',
    emoji: '🎲',
    image: 'assets/images/ideas_images/boardGames.jpg',
    description:
    'Enjoy a fun and relaxing night in with your favorite board games.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Go dancing',
    emoji: '💃',
    image: 'assets/images/ideas_images/dancing.jpg',
    description:
    'Hit the dance floor and dance the night away at a club or a dance class.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Visit a fair',
    emoji: '🎪',
    image: 'assets/images/ideas_images/fair.jpg',
    description:
    'Explore a local festival or fair and enjoy the food, games, and attractions.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Go for a bike ride',
    emoji: '🚴',
    image: 'assets/images/ideas_images/BikeRide.jpg',
    description:
    'Take a leisurely bike ride together and explore your surroundings.',
    widget: PopularMoviesAndShows(),
  ),
  Activity_class(
    title: 'Go to a concert',
    emoji: '🎤',
    image: 'assets/images/ideas_images/Concert.jpg',
    description:
    'Enjoy a night of live music together at a concert or music festival.',
    widget: PopularMoviesAndShows(),
  ),
];

class DateIdeas extends StatefulWidget {
  @override
  _DateIdeasState createState() => _DateIdeasState();
}

class _DateIdeasState extends State<DateIdeas> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;



    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
        elevation: 0,
        backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
        title: Text(
          'Kankei',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController, // Add this line to link the textController to the TextField
              decoration: const InputDecoration(
                labelText: 'Get inspiration',
                hintText: 'Let us find you new ideas',
                prefixIcon: Icon(
                  Icons.search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                    color: Colors.purple,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                    color: Colors.purple,
                    width: 2.0,
                  ),
                ),
              ),

              onEditingComplete: () {
                String enteredText2 = textController.text;
                print(enteredText2);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(prompt: enteredText2)),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: activities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DateDetails(activity: activities[index])),
                    );
                  },
                  child: Card(
                    color: is_dark ? Colors.grey.shade900 : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      side: BorderSide(
                        color: Color(0xFFEAE7FA),
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          activities[index].emoji,
                          style: TextStyle(fontSize: 60.0,
                          color: is_dark ? Colors.purple : Colors.purple),
                        ),
                        Text(activities[index].title),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
