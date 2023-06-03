import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme_system.dart';



// Stateful : means the widget can have mutable state.
class AddEventPage extends StatefulWidget {
  final VoidCallback updateEventsCallback;
  const AddEventPage({Key? key, required this.updateEventsCallback}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  String name_of_event = '';
  /* date_selected initialized with the current date and time so that when user
  chooses, he is proposed the current date first
   */
  DateTime date_selected = DateTime.now();
  String description_event = '';
  // We use map to associate each category name with its corresponding color
  Map<String, Color> categories = {};
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _retrieveCategories();
  }

  // Save the categories to shared preferences
  Future<void> _saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the categories map to a JSON string
    String categoriesString = jsonEncode(categories.map((key, value) => MapEntry(key, value.value)));
    await prefs.setString('categories', categoriesString);
  }

  // Retrieve the categories from shared preferences
  Future<void> _retrieveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesString = prefs.getString('categories');
    if (categoriesString != null) {
      setState(() {
        // Decode the JSON string and convert it back to a map
        Map<String, dynamic> categoriesMap = jsonDecode(categoriesString);
        categories = categoriesMap.map((key, value) => MapEntry(key, Color(value)));
      });
    }
  }

  void _addCategory(BuildContext context) {
    if (Platform.isIOS) {
      // Show CupertinoAlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String newCategory = '';

          return CupertinoAlertDialog(
            title: const Text('Add Category'),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onChanged: (value){
                  newCategory = value;
                },
                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Add category'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (categories.containsKey(newCategory)) {
                    // The category already exists, show an alert to the user
                    if (Platform.isIOS) {
                      // Show CupertinoAlertDialog
                      showDialog(
                        context: context,
                        builder: (context) {

                          return CupertinoAlertDialog(
                            title: Text('Category already exists'),
                            content: Text(
                                'A category with the name "$newCategory" already exists.'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(
                                  'OK',
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Category already exists'),
                            content: Text(
                                'A category with the name "$newCategory" already exists.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // The category does not exist, add it to the categories map
                    setState(() {
                      if (newCategory.isNotEmpty) {
                        categories[newCategory] =
                            Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(0.6);
                        selectedCategory = newCategory;
                        _saveCategories(); // Save categories to shared preferences
                      }
                    });
                  }
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
          builder: (BuildContext context){
            String newCategory = '';

            return AlertDialog(
              title: Text('Add Category'),
              content: TextField(
                onChanged: (value) {
                  newCategory = value;
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Add category'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (categories.containsKey(newCategory)) {
                      // The category already exists, show an alert to the user
                      if (Platform.isIOS) {
                        // Show CupertinoAlertDialog
                        showDialog(
                          context: context,
                          builder: (context) {

                            return CupertinoAlertDialog(
                              title: Text('Category already exists'),
                              content: Text(
                                  'A category with the name "$newCategory" already exists.'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(
                                    'OK',
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Category already exists'),
                              content: Text(
                                  'A category with the name "$newCategory" already exists.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // The category does not exist, add it to the categories map
                      setState(() {
                        if (newCategory.isNotEmpty) {
                          categories[newCategory] =
                              Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                  .withOpacity(0.6);
                          selectedCategory = newCategory;
                          _saveCategories(); // Save categories to shared preferences
                        }
                      });
                    }
                  },
                ),
              ],
            );
          }
      );
    }
  }

  // Function to show date picker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 230,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (val) {
                    setState(() {
                      date_selected = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show Material DatePicker
      final DateTime? picked_date = await showDatePicker(
        context: context,
        initialDate: date_selected,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024),
      );

      if (picked_date != null && picked_date != date_selected) {
        setState(() {
          date_selected = picked_date;
        });
      }
    }
  }

  void _deleteCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
      _saveCategories(); // Save categories to shared preferences
    });
  }


  void deleteEventsByCategory(String categoryName) async {
    // Delete all documents from Firestore whose category field matches the deleted category
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('calendar_events')
        .where('category', isEqualTo: categoryName)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // Update the state variable
    widget.updateEventsCallback();
  }


  // Function that asks the user if he wants the event to be paired
  Future<bool> _shouldEventBePaired(BuildContext context) async {
    bool? result = false;
    if (Platform.isIOS) {
      result = await showCupertinoModalPopup<bool>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Linked Event'),
          content: const Text('Do you wish to share this event with your paired partner ?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Linked Event'),
          content: const Text('Do you wish to share this event with your paired partner ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),

              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
    return result ?? false;
  }


  Future<void> addEventFirebase(name,description,category,date,isShared) async {

    try{
      DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
      String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');


      // Create a new document in the calendar_events sub-collection for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('calendar_events')
          .add({
        'name': name,
        'description': description,
        'category': category,
        'date': date,
        'is_shared': isShared
      });

      // If isShared is true, create a new document in the calendar_events sub-collection for the linked user
      if (isShared) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(linkedUserUid)
            .collection('calendar_events')
            .add({
          'name': name,
          'description': description,
          'category': category,
          'date': date,
          'is_shared': isShared
        });
      }
    } catch (error) {
      print('Error caught: $error');
    }

    }

    // This is the function that adds the event in the firebase cloud
  Future<void> _createEvent(date, categoryColor) async {
    // We get the list of events from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('calendar_events')
        .get();

    // We then heck if any of the events have the same name as the new event
    bool does_event_exist = querySnapshot.docs.any((doc) => doc.data()['name'] == name_of_event);

    if (does_event_exist) {
      // An event with the same name already exists, show an alert to the user
      if (Platform.isIOS) {
        // Show CupertinoAlertDialog
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Event already exists'),
              content: Text('An event with the name "$name_of_event" already exists.'),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'OK',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      } else {
        // Show Material AlertDialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Event already exists'),
              content: Text('An event with the name "$name_of_event" already exists.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // No event with the same name exists, so we add the new event to Firestore
      bool isShared = await _shouldEventBePaired(context);
      await addEventFirebase(name_of_event, description_event, selectedCategory, date, isShared);
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    Widget buildCategoryItem(String categoryName, Color categoryColor) {
      bool isSelected = categoryName == selectedCategory; // Check if the category is selected


      return GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedCategory = ''; // Deselect the category if already selected
            } else {
              selectedCategory = categoryName; // Select the category
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.0,
            children: [
              Chip(
                label: Text(
                  categoryName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black, // Change text color based on selection
                  ),
                ),
                backgroundColor: isSelected ? categoryColor : Colors.white, // Change chip color based on selection
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {

                  if (Platform.isIOS) {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Deleting Category'),
                        content: const Text("You're about to delete all events linked to this category. Do you still wish to pursue ?"),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          CupertinoDialogAction(
                            onPressed: () async {
                              _deleteCategory(categoryName);
                              // Get the list of events from Firestore
                              QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUserUid)
                                  .collection('calendar_events')
                                  .get();

                              // Check if any of the events have the given category
                              bool hasEvents = querySnapshot.docs.any((doc) => doc.data()['category'] == categoryName);

                              // Only call deleteEventsByCategory if the category has events
                              if (hasEvents) {
                                deleteEventsByCategory(categoryName);
                                widget.updateEventsCallback();
                              }

                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Deleting Category'),
                        content: const Text("You're about to delete all events linked to this category. Do you still wish to pursue ?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              _deleteCategory(categoryName);
                              // Get the list of events from Firestore
                              QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUserUid)
                                  .collection('calendar_events')
                                  .get();

                              // Check if any of the events have the given category
                              bool hasEvents = querySnapshot.docs.any((doc) => doc.data()['category'] == categoryName);

                              // Only call deleteEventsByCategory if the category has events
                              if (hasEvents) {
                                deleteEventsByCategory(categoryName);
                                widget.updateEventsCallback();
                              }

                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

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
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 40.0),
              // Adjust the left padding as needed
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text('Add New Event',
                    textAlign: TextAlign.center,
                    style: TextStyle (
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                    child: TextField(
                      onChanged: (value){
                        setState((){
                          name_of_event = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.planning_add_event_color),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.planning_add_event_color),
                        ),
                        hintText: 'Enter event name',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 110,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          description_event = value;
                        });
                      },
                      maxLines: null, // Allows the text field to dynamically adjust its height
                      decoration:
                      InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.planning_add_event_color), // Set the desired border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.planning_add_event_color),
                        ),
                        hintText: 'Enter event description',
                      ),
                    ),
                  ),
                  Container(
                    height: 50, // Adjust the height as per your requirements
                    child: TextFormField(
                      onTap: () => _selectDate(context),
                      readOnly: true, // Prevents direct editing of the text field
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.planning_add_event_color), // Set the desired border color
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.planning_add_event_color)),
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: '${date_selected.day}/${date_selected.month}/${date_selected.year}',
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Text(
                    'Select a category:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  ElevatedButton(
                    onPressed: () => _addCategory(context),
                    child: Text('Add Category',
                        style: TextStyle(color: is_dark ? Colors.white : Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          is_dark ? AppColors.dark_appbar_header.withOpacity(0.8) : AppColors.planning_add_event_color.withOpacity(0.8) ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Wrap(
                    spacing: 8.0, // Adjust the spacing between categories as needed
                    children: categories.entries.map((entry) {
                      final categoryName = entry.key;
                      final categoryColor = entry.value;
                      return buildCategoryItem(categoryName, categoryColor);
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            Container(
              width: 250,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Inside the AddEventPage widget
                onPressed: () async {
                  if (name_of_event.isEmpty || selectedCategory.isEmpty) {
                    if (Platform.isIOS) {
                      // Show CupertinoAlertDialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter a name and select a category for the event.'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(
                                  'OK',

                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Show Material AlertDialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter a name and select a category for the event.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    DateTime date = DateTime(date_selected.year, date_selected.month, date_selected.day);
                    Color? categoryColor = categories[selectedCategory];
                    await _createEvent(date, categoryColor);
                    // Update the state variable
                    widget.updateEventsCallback();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Event',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}