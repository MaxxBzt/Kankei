import 'package:flutter/material.dart';
import 'package:kankei/theme/theme_system.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'inspiration.dart';
import 'app_colors.dart';
import 'dart:io';
import 'date_details.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Ideas extends StatefulWidget {
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {

  Future<void> _launchURL(String url) async {
    final Uri urlWeb = Uri.parse(url);
    if (await canLaunchUrl(urlWeb)) {
      await launchUrl(urlWeb,mode: Platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $urlWeb'),
        ),
      );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Fun & Romantic Ideas',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive',
                  color: is_dark ? Colors.white : Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: is_dark
                          ? AppColors.dark_appbar_header
                          : Colors.purple.shade100,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DateIdeas()),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Dates',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cursive',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: AspectRatio(
                      aspectRatio: 1.8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemExtent: 300,
                            itemBuilder: (BuildContext context, int index) {
                              List<String> imagePaths = [
                                'assets/images/ideas_images/watch_movie_ideas.png',
                                'assets/images/ideas_images/cooking_ideas.png',
                                'assets/images/ideas_images/restaurant_ideas.png',
                              ];
                              List<String> routes = [
                                '/DateDetailsShow',
                                '/DateDetailsRecipe',
                              ];
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, routes[index]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        imagePaths[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DateIdeas()));
              },
              child: Text(
                'See more >',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: is_dark ? AppColors.light_Ideas : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quiz',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1.8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemExtent: 300,
                                itemBuilder: (BuildContext context, int index) {
                                  List<String> imagePaths = [
                                    'assets/images/ideas_images/general_knowledge.png',
                                    'assets/images/ideas_images/Personality_Quiz.png',
                                    'assets/images/ideas_images/restaurant_ideas.png',
                                  ];

                                  List<String> routes = [
                                    '/Quiz_General_Knowledge',
                                    '/Quiz_Personality',
                                  ];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, routes[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            imagePaths[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: is_dark ? AppColors.dark_Ideas : AppColors.light_Ideas,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Gifts',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1.8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemExtent: 150,
                                itemBuilder: (BuildContext context, int index) {

                                  final List<String> imageUrls = [
                                    'assets/images/products_images/headphones.jpg',
                                    'assets/images/products_images/backpack.png',
                                    'assets/images/products_images/zelda.png',
                                    'assets/images/products_images/Vinyle.png',
                                    'assets/images/products_images/bracelet.png',
                                    // Add more image URLs here
                                  ];

                                  final List<String> giftLinks = [
                                    'https://www.amazon.fr/Sony-WH1000XM4-Bluetooth-dautonomie-téléphoniques/dp/B08C7KCJF5',
                                    'https://www.fr.rains.com/products/backpack?variant=41009057497271',
                                    'https://www.fnac.com/a16018065/The-Legend-of-Zelda-Tears-Of-The-Kingdom-Nintendo-Switch-Jeu-video-Nintendo-Switch',
                                    'https://vinylcollector.store/products/the-weeknd-starboy-double-vinyle-rouge',
                                    'https://www.hermes.com/fr/fr/product/bracelet-clic-h-H700001FP01PM/',
                                    // Add corresponding URLs for the gift ideas
                                  ];

                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchURL(giftLinks[index]);
                                        print("hey");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          child: Image.asset(
                                            imageUrls[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
