import 'dart:collection';
import 'dart:developer';

import 'package:device_calendar/device_calendar.dart';
import 'package:f1_calendar/core/components/my_year_picker.dart';
import 'package:f1_calendar/core/globals.dart';
import 'package:f1_calendar/core/services/ergast.service.dart';
import 'package:f1_calendar/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NewPage extends StatefulWidget{
  const NewPage({Key? key}) : super(key: key);

  @override
  NewPageState createState() =>NewPageState();
}

class NewPageState extends State{
  late DeviceCalendarPlugin deviceCalendarPlugin;
  List<String> seasons = [];
  CalendarData? calendarData;
  DateTime selectedDate = DateTime.now();

  bool chkRaces = false;
  bool chkQualifying = false;
  bool chkSprint = false;
  bool chkFirstPractice = false;
  bool chkSecondPractice = false;
  bool chkThirdPractice = false;

  List<Calendar> writableCalendars = [];
  String selectedCalendarID = '';

  @override
  void initState() {
    deviceCalendarPlugin = DeviceCalendarPlugin();
    retrieveCalendars();
    getRaces(selectedDate.year.toString()).then((value) {
      setState(() {
        calendarData = value;
      });
    });

    getSeasons().then((value) {
      setState(() {
        seasons = value.mRData.seasonTable!.seasons; 
      });
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:  Column(
          children: [
            MyYearPicker(
              label: 'Season',
              alertLabel: 'Choose a season',
              startDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.first)) : DateTime.now(), 
              endDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.last)) : DateTime.now(), 
              selectedDate: selectedDate, 
              onChanged: (d) => handleYearPickerChange(d), 
            ),
            SizedBox(height: 32,),
            Text("Choose your calendar",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCalendarID,
              items: writableCalendars.map((Calendar value) =>
                DropdownMenuItem(
                  value: value.id,
                  child: Text("${value.name!} - ${value.accountType!}"),
                )
              ).toList(),
              onChanged: handleCalendarChange
            ),
            SizedBox(height: 32,),
            Text("Choose what to save in the calendar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            CheckboxListTile(
              title: Text("First Practice"),
              value: chkFirstPractice,
              onChanged: (newValue) {
                setState(() {
                  chkFirstPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text("Second Practice"),
              value: chkSecondPractice,
              onChanged: (newValue) {
                setState(() {
                  chkSecondPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text("Third Practice"),
              value: chkThirdPractice,
              onChanged: (newValue) {
                setState(() {
                  chkThirdPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text("Sprint Race"),
              value: chkSprint,
              onChanged: (newValue) {
                setState(() {
                  chkSprint = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text("Qualifying"),
              value: chkQualifying,
              onChanged: (newValue) {
                setState(() {
                  chkQualifying = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text("Race"),
              value: chkRaces,
              onChanged: (newValue) {
                setState(() {
                  chkRaces = newValue!;
                });
              }
            ),
            SizedBox(height: 64,),
            ElevatedButton(
              onPressed: saveEvents, 
              child: Text("PROCEED")
            )
          ],
        ),
      )
    );
  }

  handleYearPickerChange(DateTime d){
    getRaces(d.year.toString()).then((value) {
      setState(() {
        calendarData = value;
      });
    });
    setState(() {
      selectedDate = d;
    });


  }

  handleCalendarChange(String? newCalendarID){
    if(newCalendarID != null){
      setState(() {
        selectedCalendarID = newCalendarID;
      });
    }
  }

  void retrieveCalendars() async {
    try {
      var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();

      var calendars = calendarsResult.data as List<Calendar>;

      List<Calendar> tmpCalendars = calendars.where((e) => (e.isReadOnly != null && !e.isReadOnly!)).toList();

      if(tmpCalendars.isNotEmpty){
        setState(() {
          selectedCalendarID = tmpCalendars.first.id!;
          writableCalendars = tmpCalendars;
        });

      }
    }
    catch(e){
      EasyLoading.showError(
        'An error occurred while reading the device calendars, check the permission and try again', 
        duration: Duration(seconds: 10), 
        dismissOnTap: true
      );
    }
  }

  saveEvents() async{
    increaseCounter();
    if(selectedCalendarID == ''){
      EasyLoading.showError("Select a valid calendar");
      return;
    }

    if(calendarData == null){
      EasyLoading.showError("An Error occurred while retriving data online");
      return;
    }

    if(chkFirstPractice && chkSecondPractice && chkThirdPractice && chkQualifying && chkRaces){
      EasyLoading.showError("Select at least one option from the checkboxes");
      return;
    }

    //CHECK IF ALREADY EXISTS THE EVENT ON THE CALENDAR
    Result<UnmodifiableListView<Event>> tmpCalendarEvents = await deviceCalendarPlugin.retrieveEvents(
      selectedCalendarID,
      RetrieveEventsParams(
        startDate: DateTime(selectedDate.year),
        endDate: DateTime(selectedDate.year, 12, 31)
      )
    );

    List<Event> calendarEvents = tmpCalendarEvents.data as List<Event>;
    tz.initializeTimeZones();

    for (var race in calendarData!.mRData.raceTable!.races) {
      Event currentEvent = Event(selectedCalendarID);

      //race info
      TZDateTime startDate = TZDateTime.parse(getLocation('Europe/Rome'), "${race.date} ${race.time}");
      TZDateTime endDate = startDate.add(const Duration(hours: 1));
      String title = race.raceName;

      for (var event in calendarEvents) {
        if (event.title == race.raceName) {
          currentEvent = event;
        }
      }

      currentEvent.start = startDate;
      currentEvent.end = endDate;
      currentEvent.title = title;

      deviceCalendarPlugin.createOrUpdateEvent(currentEvent);
    }
    decreseCounter();
  }
}