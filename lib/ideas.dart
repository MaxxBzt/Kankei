import 'package:flutter/material.dart';
import 'inspiration.dart';
import 'app_colors.dart';
import 'dart:io';

class Ideas extends StatefulWidget {
  @override
  _IdeasState createState() => _IdeasState();
}



class _IdeasState extends State<Ideas> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DateIdeas()),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.Dates,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dates',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add some vertical spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                  child: AspectRatio(
                    aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Set the desired border radius
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/ideas_images/artGallery.jpeg', // Replace with actual asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                  child: AspectRatio(
                    aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Set the desired border radius
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/ideas_images/picnic.jpg', // Replace with actual asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),


          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.Quiz,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Quiz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 // Add vertical spacing
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
                      padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                      child: AspectRatio(
                        aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), // Set the desired border radius
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/ideas_images/restaurant.jpg', // Replace with actual asset path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                      child: AspectRatio(
                        aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), // Set the desired border radius
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/ideas_images/stargazing.jpg', // Replace with actual asset path
                              fit: BoxFit.cover,
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

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.Gifts,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Gifts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 // Add vertical spacing
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                  child: AspectRatio(
                    aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Set the desired border radius
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/ideas_images/go_hiking.jpg', // Replace with actual asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal spacing
                  child: AspectRatio(
                    aspectRatio: 1, // Set the desired aspect ratio (1:1 in this case)
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Set the desired border radius
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/ideas_images/watch_movie.png', // Replace with actual asset path
                          fit: BoxFit.cover,
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
    );
  }
}


