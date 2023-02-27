// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FirstPageState();
  }
}

class _FirstPageState extends State<FirstPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  _FirstPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  List<Calendar> _writableCalendars = [];
  Calendar _selectedCalendar = Calendar();

  bool _races = false;
  bool _qualifying = false;
  bool _sprint = false;
  bool _firstPractice = false;
  bool _secondPractice = false;
  bool _thirdPractice = false;

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

  //This retrive all the calendars with write permission
  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

      var calendars = calendarsResult.data as List<Calendar>;
      var writableCalendars =
          calendars.where((c) => c.isReadOnly == false).toList();

      setState(() {
        _writableCalendars = writableCalendars;
        _selectedCalendar = writableCalendars[0];
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text("F1 Calendar")),
      body: Column(children: [
        Text("Choose your calendar"),
        DropdownButton<Calendar>(
          value: _selectedCalendar,
          items: _writableCalendars.map((Calendar value) {
            return DropdownMenuItem<Calendar>(
              value: value,
              child: Text("${value.name!} - ${value.accountType!}"),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCalendar = value!;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        Text("Choose what to save in the calendar"),
        CheckboxListTile(
            title: Text("First Practice"),
            value: _firstPractice,
            onChanged: (newValue) {
              setState(() {
                _firstPractice = newValue!;
              });
            }),
        CheckboxListTile(
            title: Text("Second Practice"),
            value: _secondPractice,
            onChanged: (newValue) {
              setState(() {
                _secondPractice = newValue!;
              });
            }),
        CheckboxListTile(
            title: Text("Third Practice"),
            value: _thirdPractice,
            onChanged: (newValue) {
              setState(() {
                _thirdPractice = newValue!;
              });
            }),
        CheckboxListTile(
            title: Text("Sprint Race"),
            value: _sprint,
            onChanged: (newValue) {
              setState(() {
                _sprint = newValue!;
              });
            }),
        CheckboxListTile(
            title: Text("Qualifying"),
            value: _qualifying,
            onChanged: (newValue) {
              setState(() {
                _qualifying = newValue!;
              });
            }),
        CheckboxListTile(
            title: Text("Race"),
            value: _races,
            onChanged: (newValue) {
              setState(() {
                _races = newValue!;
              });
            }),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              if (_selectedCalendar == Calendar()) {
                print("Non è stato selezionato un calendario");
                print(_selectedCalendar.name);
              }
            },
            child: Text("Save"))
      ]),
    ));
  }
}
