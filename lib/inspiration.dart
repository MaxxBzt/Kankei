import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'date_details.dart';

class DateIdeas extends StatefulWidget {
  @override
  _DateIdeasState createState() => _DateIdeasState();
}

class _DateIdeasState extends State<DateIdeas> {
  List<Map<String, String>> activities = [
    {
      'title': 'Watch a movie',
      'emoji': '🎬',
      'image': 'assets/images/ideas_images/watch_movie.png',
      'description':
          'Enjoy a cozy movie night together at home or at a theater.'
    },
    {
      'title': 'Cook together',
      'emoji': '🍳',
      'image': 'assets/images/cook_together.jpg',
      'description':
          'Prepare a delicious meal together and have fun in the kitchen.'
    },
    {
      'title': 'Go for a hike',
      'emoji': '🥾',
      'image': 'assets/images/go_hiking.jpg',
      'description':
          'Explore nature together and enjoy some fresh air on a hiking trail.'
    },
    {
      'title': 'Visit an art gallery',
      'emoji': '🎨',
      'image': 'assets/images/art_gallery.jpg',
      'description':
          'Discover and appreciate art together at a local gallery or museum.'
    },
    {
      'title': 'Have a picnic',
      'emoji': '🧺',
      'image': 'assets/images/picnic.jpg',
      'description':
          'Pack a basket with your favorite foods and enjoy a meal outdoors.'
    },
    {
      'title': 'Stargazing',
      'emoji': '🌠',
      'image': 'assets/images/stargazing.jpg',
      'description':
          'Find a quiet spot away from city lights and marvel at the night sky.'
    },
    {
      'title': 'Play board games',
      'emoji': '🎲',
      'image': 'assets/images/board_games.jpg',
      'description':
          'Enjoy a fun and relaxing night in with your favorite board games.'
    },
    {
      'title': 'Go dancing',
      'emoji': '💃',
      'image': 'assets/images/dancing.jpg',
      'description':
          'Hit the dance floor and dance the night away at a club or a dance class.'
    },
    {
      'title': 'Visit a local festival',
      'emoji': '🎪',
      'image': 'assets/images/festival.jpg',
      'description':
          'Explore a local festival or fair and enjoy the food, games, and attractions.'
    },
    {
      'title': 'Go for a bike ride',
      'emoji': '🚴',
      'image': 'assets/images/bike_ride.jpg',
      'description':
          'Take a leisurely bike ride together and explore your surroundings.'
    },
  ];
  // Add other activities with their images and descriptions here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.purple,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Get inspiration',
                    hintText: 'Let us find you new ideas',
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
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
                  onChanged: (value) {
                    // Handle search functionality here
                  },
                ),
              )),
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
                            DateDetails(activity: activities[index]),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
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
                          activities[index]['emoji']!,
                          style: TextStyle(fontSize: 40.0),
                        ),
                        Text(activities[index]['title']!),
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
