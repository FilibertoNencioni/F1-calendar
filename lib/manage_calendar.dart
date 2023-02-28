import 'dart:developer';

import 'package:device_calendar/device_calendar.dart';
import 'package:f1_calendar/core/services/ergast.service.dart';
import 'package:f1_calendar/models/calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class CalendarsPage extends StatefulWidget {
  const CalendarsPage({Key? key}) : super(key: key);

  @override
  CalendarsPageState createState() => CalendarsPageState();
}

class CalendarsPageState extends State<CalendarsPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;

  @override
  void initState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    // _retrieveCalendars();
    super.initState();
  }



  // void _retrieveCalendars() async {
  //   try {
  //     var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
  //     if (permissionsGranted.isSuccess &&
  //         (permissionsGranted.data == null ||
  //             permissionsGranted.data == false)) {
  //       permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
  //       if (!permissionsGranted.isSuccess ||
  //           permissionsGranted.data == null ||
  //           permissionsGranted.data == false) {
  //         return;
  //       }
  //     }

  //     final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

  //     //DEBUG
  //     var calendars = calendarsResult.data as List<Calendar>;
  //     var writableCalendars =
  //         calendars.where((c) => c.isReadOnly == false).toList();
  //     Calendar myCalendar = calendars.first;

  //     for (var element in writableCalendars) {
  //       if (element.name!.contains("@gmail.com")) {
  //         myCalendar = element;
  //       }
  //     }

  //     var tmpCalendarEvents = await _deviceCalendarPlugin.retrieveEvents(
  //         myCalendar.id,
  //         RetrieveEventsParams(
  //             startDate: DateTime.parse("2022-01-01"),
  //             endDate: DateTime.parse("2022-12-31")));

  //     List<Event> calendarEvents = tmpCalendarEvents.data as List<Event>;
  //     CalendarData races = await getRaces();
  //     tz.initializeTimeZones();

  //     for (var race in races.mRData.raceTable!.races!) {
  //       Event foundEvent = Event(myCalendar.id);

  //       //race info
  //       TZDateTime startDate = TZDateTime.parse(
  //         getLocation('Europe/Rome'), "${race.date!} ${race.time!}");
  //       TZDateTime endDate = startDate.add(const Duration(hours: 1));
  //       String title = race.raceName!;

  //       for (var event in calendarEvents) {
  //         if (event.title == race.raceName) {
  //           foundEvent = event;
  //         }
  //       }

  //       foundEvent.start = startDate;
  //       foundEvent.end = endDate;
  //       foundEvent.title = title;

  //       var createdEvent =
  //           _deviceCalendarPlugin.createOrUpdateEvent(foundEvent);
  //       log(createdEvent.toString());
  //     }
  //   } on PlatformException catch (e) {
  //     log(e.toString());
  //   }
  // }

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
