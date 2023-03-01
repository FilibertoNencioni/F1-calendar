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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

  bool chkRace = false;
  bool chkQualifying = false;
  bool chkSprint = false;
  bool chkFirstPractice = false;
  bool chkSecondPractice = false;
  bool chkThirdPractice = false;

  List<Calendar> writableCalendars = [];
  String selectedCalendarID = '';

  @override
  void initState() {
    tz.initializeTimeZones();
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
      appBar: AppBar(title: const Text('F1 Calendar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:  Column(
          children: [
            Text(
              AppLocalizations.of(context)!.choose_season, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            MyYearPicker(
              label: AppLocalizations.of(context)!.season,
              alertLabel: AppLocalizations.of(context)!.choose_season,
              startDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.first)) : DateTime.now(), 
              endDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.last)) : DateTime.now(), 
              selectedDate: selectedDate, 
              onChanged: (d) => handleYearPickerChange(d), 
            ),
            SizedBox(height: 64,),
            Text(
              AppLocalizations.of(context)!.choose_calendar,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
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
            SizedBox(height: 64,),
            Text(
              AppLocalizations.of(context)!.choose_event, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.first_practice),
              value: chkFirstPractice,
              onChanged: (newValue) {
                setState(() {
                  chkFirstPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.second_practice),
              value: chkSecondPractice,
              onChanged: (newValue) {
                setState(() {
                  chkSecondPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.third_practice),
              value: chkThirdPractice,
              onChanged: (newValue) {
                setState(() {
                  chkThirdPractice = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.sprint_race),
              value: chkSprint,
              onChanged: (newValue) {
                setState(() {
                  chkSprint = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.qualifying),
              value: chkQualifying,
              onChanged: (newValue) {
                setState(() {
                  chkQualifying = newValue!;
                });
              }
            ),
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.race),
              value: chkRace,
              onChanged: (newValue) {
                setState(() {
                  chkRace = newValue!;
                });
              }
            ),
            SizedBox(height: 64,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: saveEvents, 
                  child: Text(AppLocalizations.of(context)!.proceed)
                ),
                ElevatedButton(
                  onPressed: deleteEvents, 
                  child: Text(AppLocalizations.of(context)!.delete_all_from_calendar),
                )
              ],
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
        AppLocalizations.of(context)!.error_read_calendars, 
        duration: Duration(seconds: 10), 
        dismissOnTap: true
      );
    }
  }

  deleteEvents() async{
    increaseCounter();
    //CHECK IF ALREADY EXISTS THE EVENT ON THE CALENDAR
    Result<UnmodifiableListView<Event>> tmpCalendarEvents = await deviceCalendarPlugin.retrieveEvents(
      selectedCalendarID,
      RetrieveEventsParams(
        startDate: DateTime(selectedDate.year),
        endDate: DateTime(selectedDate.year, 12, 31)
      )
    );

    List<Event> calendarEvents = tmpCalendarEvents.data as List<Event>;
    for (Event event in calendarEvents) {
      deviceCalendarPlugin.deleteEvent(selectedCalendarID, event.eventId);
    }
    decreseCounter();
  }

  saveEvents() async{
    increaseCounter();
    if(selectedCalendarID == ''){
      EasyLoading.showError(AppLocalizations.of(context)!.warning_calendar_nor_selected);
      return;
    }

    if(calendarData == null){
      EasyLoading.showError(AppLocalizations.of(context)!.error_fetch_data);
      return;
    }

    if(chkFirstPractice && chkSecondPractice && chkThirdPractice && chkQualifying && chkRace){
      EasyLoading.showError(AppLocalizations.of(context)!.warning_select_option);
      return;
    }

    List<Event> eventsToAdd = [];

    for (var race in calendarData!.mRData.raceTable!.races) {

      if(chkRace){
        Event currentEvent = Event(selectedCalendarID);
        //race info
        TZDateTime startDate = TZDateTime.parse(getLocation('Europe/Rome'), "${race.date} ${race.time}");
        TZDateTime endDate = startDate.add(const Duration(hours: 1));
        String title = race.raceName;

        currentEvent.start = startDate;
        currentEvent.end = endDate;
        currentEvent.title = title;
        eventsToAdd.add(currentEvent);
      }

      if(chkFirstPractice && race.firstPractice != null){
        Event currentEvent = Event(selectedCalendarID);
        currentEvent.start = TZDateTime.parse(getLocation('Europe/Rome'), "${race.firstPractice!.date} ${race.firstPractice!.time}");
        currentEvent.end = currentEvent.start!.add(const Duration(hours: 1));
        currentEvent.title = "${race.raceName} - ${AppLocalizations.of(context)!.first_practice}";
        eventsToAdd.add(currentEvent);
      }

      if(chkSecondPractice && race.secondPractice != null){
        Event currentEvent = Event(selectedCalendarID);
        currentEvent.start = TZDateTime.parse(getLocation('Europe/Rome'), "${race.secondPractice!.date} ${race.secondPractice!.time}");
        currentEvent.end = currentEvent.start!.add(const Duration(hours: 1));
        currentEvent.title = "${race.raceName} - ${AppLocalizations.of(context)!.second_practice}";
        eventsToAdd.add(currentEvent);
      }

      if(chkThirdPractice && race.thirdPractice != null){
        Event currentEvent = Event(selectedCalendarID);
        currentEvent.start = TZDateTime.parse(getLocation('Europe/Rome'), "${race.thirdPractice!.date} ${race.thirdPractice!.time}");
        currentEvent.end = currentEvent.start!.add(const Duration(hours: 1));
        currentEvent.title = "${race.raceName} - ${AppLocalizations.of(context)!.third_practice}";
        eventsToAdd.add(currentEvent);
      }

      if(chkSprint && race.sprint != null){
        Event currentEvent = Event(selectedCalendarID);
        currentEvent.start = TZDateTime.parse(getLocation('Europe/Rome'), "${race.sprint!.date} ${race.sprint!.time}");
        currentEvent.end = currentEvent.start!.add(const Duration(hours: 1));
        currentEvent.title = "${race.raceName} - ${AppLocalizations.of(context)!.sprint_race}";
        eventsToAdd.add(currentEvent);
      }

      if(chkQualifying && race.qualifying != null){
        Event currentEvent = Event(selectedCalendarID);
        currentEvent.start = TZDateTime.parse(getLocation('Europe/Rome'), "${race.qualifying!.date} ${race.qualifying!.time}");
        currentEvent.end = currentEvent.start!.add(const Duration(hours: 1));
        currentEvent.title = "${race.raceName} - ${AppLocalizations.of(context)!.qualifying}";
        eventsToAdd.add(currentEvent);
      }

    }

    //ADD EVENTS TO CALENDAR
    for (Event e in eventsToAdd)  {
      await deviceCalendarPlugin.createOrUpdateEvent(e);
    }

    decreseCounter();
    EasyLoading.showSuccess(AppLocalizations.of(context)!.events_inserted_successfully, duration: Duration(seconds: 5), dismissOnTap: true);
  }
}