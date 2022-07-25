import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'models/calendar.dart' as model;
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class CalendarsPage extends StatefulWidget {
  CalendarsPage({Key? key}) : super(key: key);

  @override
  _CalendarsPageState createState() {
    return _CalendarsPageState();
  }
}

class _CalendarsPageState extends State<CalendarsPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  _CalendarsPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

  Future<model.Calendar> fetchRaces() async {
    final response =
        await http.get(Uri.parse('https://ergast.com/api/f1/2022.json'));

    if (response.statusCode == 200) {
      return model.Calendar.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

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

      //DEBUG
      var calendars = calendarsResult.data as List<Calendar>;
      var writableCalendars =
          calendars.where((c) => c.isReadOnly == false).toList();
      Calendar myCalendar = calendars.first;

      writableCalendars.forEach((element) {
        if (element.name!.contains("@gmail.com")) {
          myCalendar = element;
        }
      });

      var tmpCalendarEvents = await _deviceCalendarPlugin.retrieveEvents(
          myCalendar.id,
          RetrieveEventsParams(
              startDate: DateTime.parse("2022-01-01"),
              endDate: DateTime.parse("2022-12-31")));

      List<Event> calendarEvents = tmpCalendarEvents.data as List<Event>;
      model.Calendar races = await fetchRaces();
      tz.initializeTimeZones();

      races.mRData!.raceTable!.races!.forEach((race) {
        Event foundEvent = Event(myCalendar.id);

        //race info
        TZDateTime startDate = TZDateTime.parse(
            getLocation('Europe/Rome'), race.date! + " " + race.time!);
        TZDateTime endDate = startDate.add(Duration(hours: 1));
        String title = race.raceName!;

        calendarEvents.forEach((event) {
          if (event.title == race.raceName) {
            foundEvent = event;
          }
        });

        foundEvent.start = startDate;
        foundEvent.end = endDate;
        foundEvent.title = title;

        var createdEvent =
            _deviceCalendarPlugin.createOrUpdateEvent(foundEvent);
        print(createdEvent);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: const Text("test")),
      body: (Column(
        children: [],
      )),
    ));
  }
}
