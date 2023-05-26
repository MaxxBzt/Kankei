import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Calendar_Page/event_model.dart';



// Stateful : means the widget can have mutable state.
class AddEventPage extends StatefulWidget {

  // Add a onDeleteCategory property to the AddEventPage widget
  late final void Function(String)? onDeleteCategory;
  AddEventPage({Key? key, this.onDeleteCategory}) : super(key: key);


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


  // Function to show date picker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked_date = await showDatePicker(
      context: context,
      initialDate: date_selected,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    // Here we declared a variable telling us the date currently selected by the user
    if (picked_date != null && picked_date != date_selected) {
      setState(() {
        date_selected = picked_date;
      });
    }
  }

  void _addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                setState(() {
                  if (newCategory.isNotEmpty) {
                    categories[newCategory] =
                        Color((Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0);
                    selectedCategory = newCategory;
                    _saveCategories(); // Save categories to shared preferences
                  }
                });// Close alert box
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Call the onDeleteCategory callback when a category is deleted
  void _deleteCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
      _saveCategories(); // Save categories to shared preferences
      if (widget.onDeleteCategory != null) {
        widget.onDeleteCategory!(categoryName);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
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
                  _deleteCategory(categoryName);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
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
                    child: Text('Add Category'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.planning_add_event_color.withOpacity(0.8) ),
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
                  foregroundColor: Colors.white, backgroundColor: AppColors.planning_add_event_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Inside the AddEventPage widget
                onPressed: () {
                  DateTime date = DateTime(date_selected.year, date_selected.month, date_selected.day);
                  Color? categoryColor = categories[selectedCategory];
                  Event event = Event(
                    name: name_of_event,
                    description: description_event,
                    category: selectedCategory,
                    date_of_event: date,
                    color_category: categoryColor,
                  );
                  Navigator.of(context).pop(event);

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
