
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_colors.dart';
import '../Calendar_Page/add_event_page.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;


  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      body:
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0,bottom: 8.0), // Adjust the left padding as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: AppColors.planning_add_event_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddEventPage()));
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
                      SizedBox(width: 5.0), // Adjust the width as needed
                      Image.asset(
                        'assets/images/add_plus.png',
                        width: 35, // Adjust the width as needed
                        height: 45, // Adjust the height as needed
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
                color: AppColors.planning_add_event_color,
                width: 0.5, // defines the thickness of the border
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TableCalendar(
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold,
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
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),

        ],
      ),
    );
  }
}
