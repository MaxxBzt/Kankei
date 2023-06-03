
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_colors.dart';
import '../Calendar_Page/add_event_page.dart';
import '../theme/theme_system.dart';
import 'dart:io' show Platform;

class CalendarScreen extends StatefulWidget {



  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  // This is the map of our events stored in firebase
  Map<DateTime, List<Map<String, dynamic>>> events = {};

  // This is a list containing all the events of the selected date by user
  List<Map<String, dynamic>> selectedEvents = [];
  Map<String, Color> categories = {};

  void updateEventsCallback() {
    updateEvents();
  }


  Future<void> updateEvents() async {
    // Get the events from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('calendar_events')
        .get();

    // Convert the events into the desired format
    Map<DateTime, List<Map<String, dynamic>>> newEvents = {};
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      DateTime date = (data['date'] as Timestamp).toDate();
      DateTime eventDate = DateTime(date.year, date.month, date.day);

      if (newEvents[eventDate] == null) {
        newEvents[eventDate] = [];
      }

      newEvents[eventDate]!.add(data);
    }

    // Update the state variable
    setState(() {
      events = newEvents;
    });
  }


  // Function to delete an event from calendar
  void _deleteEvent(Map<String, dynamic> event ) async {

    // We check if the event is a paired event
    bool isPaired = event['is_shared'];

    // If the event is shared
    if (isPaired){

      if (Platform.isIOS) {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Deleting Linked Event'),
            content: const Text('This Event is linked with your partner. Do you still wish to delete it ?'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {

                  // We get the name of the event to be deleted
                  String eventName = event['name'];

                  // We delete the document from Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserUid)
                      .collection('calendar_events')
                      .where('name', isEqualTo: eventName)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });

                  // Get the UID of the paired user
                  DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
                      await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
                  String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');

                  // Delete the document from the paired user's calendar_events sub-collection
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(linkedUserUid)
                      .collection('calendar_events')
                      .where('name', isEqualTo: eventName)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });
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
            title: const Text('Deleting Linked Event'),
            content: const Text('This Event is linked with your partner. Do you still wish to delete it ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {

                  // We get the name of the event to be deleted
                  String eventName = event['name'];

                  // We delete the document from Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserUid)
                      .collection('calendar_events')
                      .where('name', isEqualTo: eventName)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });

                  // Get the UID of the paired user
                  DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
                  await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
                  String linkedUserUid = currentUserSnapshot.get('LinkedAccountUID');

                  // Delete the document from the paired user's calendar_events sub-collection
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(linkedUserUid)
                      .collection('calendar_events')
                      .where('name', isEqualTo: eventName)
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });
                  Navigator.pop(context);
                },

                child: const Text('Yes'),
              ),
            ],
          ),
        );
      }

    }
    else{
      // We get the name of the event to be deleted
      String eventName = event['name'];

      // We delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('calendar_events')
          .where('name', isEqualTo: eventName)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

    }
    // Update the state variable for the displaying of events
    updateEvents();
  }


  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;




  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _retrieveCategories();
    updateEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateEvents();
  }


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
  // This function manages the popup window happening when we click to display an event
  void _openDialog(Map<String, dynamic> event) {
    if (Platform.isIOS) {
      // Show CupertinoAlertDialog
      showDialog(
        context: context,
        builder: (context) {

          return CupertinoAlertDialog(
            title: Text(event['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['description']),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Delete Event',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // Call a function to delete the event
                  Navigator.of(context).pop();
                  _deleteEvent(event);
                  updateEvents();
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
        builder: (context) {
          return AlertDialog(
            title: Text(event['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['description']),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Call a function to delete the event
                  Navigator.of(context).pop();
                  _deleteEvent(event);
                  updateEvents();
                },
                child: Text(
                  'Delete Event',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Scaffold
      (
      body:
      ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0,bottom: 8.0), // Adjust the left padding as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Map<String, dynamic>? event = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEventPage(updateEventsCallback: updateEventsCallback),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add Event',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Image.asset(
                        'assets/images/add_plus.png',
                        width: 35,
                        height: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: is_dark ? AppColors.dark_appbar_header : AppColors.planning_add_event_color,
                width: is_dark ? 2 : 0.5, // defines the thickness of the border
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child:
            Column(
              children: [
                TableCalendar(
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: is_dark ? Colors.white : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 18.0,
                      color: is_dark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: is_dark ? Colors.grey : Colors.grey[600]),

                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(color: is_dark ? Colors.white : Colors.black, fontSize: 22, fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                  ),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2013, 01, 01),
                  lastDay: DateTime.utc(2033, 01, 01),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  /*
                  eventLoader: (date) {
                    DateTime selectedDate = DateTime(date.year, date.month, date.day);
                    return events[selectedDate] ?? [];
                  },*/
                  eventLoader: (date) {
                    DateTime selectedDate = DateTime(date.year, date.month, date.day);
                    return events[selectedDate] ?? [];
                  },
                  /*
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      // Convert selectedDay to local time
                      _selectedDay = selectedDay.toLocal();

                      // Create a new DateTime object with only the date part
                      DateTime selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

                      _focusedDay = focusedDay;
                      selectedEvents = events[selectedDate]?.map((event) =>
                          event.copyWith(category: event.category, color_category: event.color_category)).toList() ?? [];

                    });
                  },*/
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay.toLocal();
                      DateTime selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
                      _focusedDay = focusedDay;
                      selectedEvents = events[selectedDate] ?? [];
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ],
            ),
          ),

          ...selectedEvents.map(
                (event) => Column(
              children: [
                GestureDetector(
                  onTap: () => _openDialog(event),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      tileColor: Colors.transparent,
                      title: Text(event['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Container(
                        color: categories[event['category']], // Use the categories map to look up the color
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text('${event['category']}', style: TextStyle(color: is_dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Add space between containers
              ],
            ),
          ).toList(),


        ],
      ),
    );
  }
}