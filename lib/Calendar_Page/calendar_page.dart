
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_colors.dart';
import '../Calendar_Page/add_event_page.dart';
import '../Calendar_Page/event_model.dart';
import '../theme/theme_system.dart';
import 'dart:io' show Platform;

class CalendarScreen extends StatefulWidget {
  final String name_of_event;
  final String description_event;
  final String selectedCategory;
  final Color color_category;
  final DateTime date_selected;


  CalendarScreen({
    required Key key,
    this.name_of_event = 'default',
    this.description_event = 'default',
    this.selectedCategory = 'default',
    this.color_category = Colors.purple,
    DateTime? date_selected,
  })  : date_selected = date_selected ?? DateTime.now(),
        super(key: key);


  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Event>> events = {};
  List<Event> selectedEvents = [];
  Map<String, Color> categories = {};


  // This function manages the adding of new events to the calendar
  void addEvent(Event event) {

    // Convert event.date to local time because it's in UTC when coming to the calendar widget
    event = event.copyWith(date: event.date_of_event.toLocal());

    // We create a new DateTime with only the date and not the time as the times varies and
    // it will mess up with our usage of the date as a key
    DateTime eventDate = DateTime(event.date_of_event.year,
        event.date_of_event.month, event.date_of_event.day);

    // Check if the date of the event already exists in the events map
    if (events[eventDate] == null) {
      // If it doesn't, create a new list for that date
      events[eventDate] = [];
    }

    // Add the event to the list of events for that date
    events[eventDate]!.add(event);
  }


  // Function to delete an event from calendar
  void _deleteEvent(Event event) {
    setState(() {
      DateTime eventDate = DateTime(event.date_of_event.year, event.date_of_event.month, event.date_of_event.day);
      events[eventDate]?.remove(event);
      selectedEvents.remove(event);
    });
  }

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;


  // Function that manages the deletion of events when a category is deleted
  void deleteEventsByCategory(String category) {
    setState(() {
      events.removeWhere((date, events) {
        events.removeWhere((event) => event.category == category);
        return events.isEmpty;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    selectedEvents = events[_selectedDay] ?? [];
  }

  // This function manages the popup window happening when we click to display an event
  void _openDialog(Event event) {
    if (Platform.isIOS) {
      // Show CupertinoAlertDialog
      showDialog(
        context: context,
        builder: (context) {

          return CupertinoAlertDialog(
            title: Text(event.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.description),
              ],
            ),
            /*
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
            ),*/
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Delete Event',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // Call a function to delete the event
                  _deleteEvent(event);
                  Navigator.of(context).pop();
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
            title: Text(event.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.description),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Call a function to delete the event
                  _deleteEvent(event);
                  Navigator.of(context).pop();
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
                    // Pass the onDeleteCategory callback to the AddEventPage widget
                    Event? event = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEventPage(onDeleteCategory: deleteEventsByCategory),
                      ),
                    );

                    if (event != null) {
                      setState(() {
                        // Widget. because variables defined as instance in the CalendarScreen class
                        addEvent(event);
                      });
                    }
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
                  eventLoader: (date) {
                    DateTime selectedDate = DateTime(date.year, date.month, date.day);
                    return events[selectedDate] ?? [];
                  },
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
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: selectedEvents.map(
                  (event) => GestureDetector(
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
                    title: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Container(
                      color: event.color_category,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text('${event.category}', style: TextStyle(color: is_dark ? Colors.white: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ).toList(),
          )
        ],
      ),
    );
  }
}