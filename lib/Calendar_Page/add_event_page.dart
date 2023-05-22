import 'package:flutter/material.dart';

import '../main.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController _eventNameController = TextEditingController();

  @override

  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  void _submitEvent() {
    String eventName = _eventNameController.text;

    // TODO: Perform any necessary operations with the event name, such as adding it to the calendar

    // Clear the text field
    _eventNameController.clear();

    // Navigate back to the calendar screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120.0, bottom: 40.0), // Adjust the left padding as needed
            child: Align(
              alignment: Alignment.center,
              child:
              Container
                (
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name*',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitEvent,
                  child: Text('Add Event'),
                ),
              ],
            ),
          ),
          Container(
            width: 150,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Back',
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
    );
  }
}
