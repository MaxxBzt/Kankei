
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io' show Platform;

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_colors.dart';
import '../main.dart';
import '../theme/theme_system.dart';
import 'dart:async';

class Card_Model {
  final String image;
  // Has the user flipped the card?
  bool isFlipped;
  // Has the card being matched?
  bool isMatched;

  Card_Model({required this.image, this.isFlipped = false, this.isMatched = false});
}

class MatchingCardGame extends StatefulWidget {
  @override
  _MatchingCardGameState createState() => _MatchingCardGameState();
}

class _MatchingCardGameState extends State<MatchingCardGame> {

  Timer? _timer;
  int _secondsRemaining = 30;
  int _numberOfAttempts = 0;


  // We create a list of the cards images
  List<String> cardImages = [
    // Add your card images here
    'assets/images/freepik_memory_cards/watermelon.jpg',
    'assets/images/freepik_memory_cards/orange.jpg',
    'assets/images/freepik_memory_cards/cherry.jpg',
    'assets/images/freepik_memory_cards/banana.jpg',
    'assets/images/freepik_memory_cards/apple.jpg',
    'assets/images/freepik_memory_cards/strawberry.jpg',
  ];

  // We create a list of the cards
  List<Card_Model> cards = [];

  // We create a list of indices to...
  List<int> flippedIndices = [];

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          endGame();
        }
      });
    });
  }



  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void initializeGame() {
    startTimer();
    // we search a random number of times to shuffle the list of cards
    final random_time_shuffled = Random();
    // We create a list of of Card_Model
    List<Card_Model> newCards = [];
    // We duplicate each cards because we need a matching pairs
    for (String image in cardImages) {
      newCards.add(Card_Model(image: image));
      newCards.add(Card_Model(image: image));
    }
    newCards.shuffle(random_time_shuffled);
    setState(() {
      // the resulting shuffled list is our cards list
      cards = newCards;
    });
  }

  // Function responsible to flip the cards (and actually play the game
  void flipCard(int index) {
    // Check if the card can be flipped based on the number of already flipped cards in the game
    // Or based on if the card was already matched
    if (flippedIndices.length < 2 && !cards[index].isFlipped && !cards[index].isMatched) {
      setState(() {
        cards[index].isFlipped = true;
        flippedIndices.add(index);
      });

      // When two cards are flipped, it compares if they are a match.
      // If match, then we pass isMatched true, if not, we re-flp the cards back
      if (flippedIndices.length == 2) {
        // We use delayed to have a delay for the flipping, for realism
        Future.delayed(Duration(seconds: 1), () {
          int index1 = flippedIndices[0];
          int index2 = flippedIndices[1];

          // If the two card have the same image, they are a match
          if (cards[index1].image == cards[index2].image) {
            setState(() {
              cards[index1].isMatched = true;
              cards[index2].isMatched = true;
            });

            if (cards.every((card) => card.isMatched)) {

              onGameWin();
              if (Platform.isIOS) {
                // Show CupertinoAlertDialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('Congratulations!'),
                      content: Text('You matched all the cards correctly.'),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(
                            'Back',
                          ),
                          onPressed: () {
                            print("Calling addScoreDailyGameFireBase with score: $_numberOfAttempts");
                            addScoreDailyGameFireBase(_numberOfAttempts,true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage()),
                            );

                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Show Material AlertDialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Congratulations!'),
                      content: Text('You matched all the cards correctly.'),
                      actions: [
                        TextButton(
                          child: Text('Back'),
                          onPressed: () {
                            print("Calling addScoreDailyGameFireBase with score: $_numberOfAttempts");
                            addScoreDailyGameFireBase(_numberOfAttempts,true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage()),
                            );

                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          } else {
            setState(() {
              cards[index1].isFlipped = false;
              cards[index2].isFlipped = false;
            });
          }

          flippedIndices.clear();
          _numberOfAttempts++;
        });
      }
    }
  }

  void onGameWin() {
    _timer?.cancel();
  }

  void endGame() {
    int minutes = (_secondsRemaining ~/ 60);
    int seconds = (_secondsRemaining % 60);

    if (Platform.isIOS) {
      // Show CupertinoAlertDialog
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Game Over'),
            content: Text('Time\'s up! Your score is $_numberOfAttempts attempts.'),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Back',
                ),
                onPressed: () {
                  // Store the user's score in Firebase Firestore
                  addScoreDailyGameFireBase(_numberOfAttempts,false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show Material AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Time\'s up! Your score is $_numberOfAttempts attempts.'),
            actions: [
              TextButton(
                child: Text('Back'),
                onPressed: () {
                  // Store the user's score in Firebase Firestore
                  addScoreDailyGameFireBase(_numberOfAttempts,false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }



  Future<void> addScoreDailyGameFireBase(score,hasWon) async {
    try {
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;


      print("addScoreDailyGameFireBase called with score: $score");
      // Create a new document in the daily_game sub-collection for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('daily_game')
          .add({
        'score': score,
        'has_played': true,
        'has_won': hasWon,
      });
      print("Document added successfully");


    } catch (error) {
      print('Error caught: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return WillPopScope(
      onWillPop: () async => false, // Disable the back gesture
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.favorite, color: is_dark ? Colors.white : Colors.black),
            elevation: 0,
            backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.light_appbar_header,
            title: Text(
              'Memory Matching Game',
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, letterSpacing: .5),
              ),
            ),
          ),
          body: Column(
              children:[
                SizedBox(height: 200.0),
                Expanded(
                  child: Center(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            flipCard(index);
                          },
                          child: Card(
                            child: cards[index].isFlipped || cards[index].isMatched
                                ? Image.asset(cards[index].image)
                                : Container(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]
          ),
        ),
    );
  }
}
