import 'dart:developer';

import 'package:f1_calendar/core/globals.dart';
import 'package:f1_calendar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Settings extends StatefulWidget{
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>{
  String currentLocale = '';
  List<String> locations = [];
  
  @override
  void initState() {
    //Get curtrent app language
    App.getLocale(context).then((newLocale){
      if(newLocale != null){
        setState(() {
          currentLocale = newLocale.languageCode;
        });
      }
    });

    //Get all locale (for timezone)
    tz.initializeTimeZones();
    List<String> tmpLocations = tz.timeZoneDatabase.locations.entries.map((e)=>e.key).toList();
    log(tmpLocations.length.toString());

    setState(() {
      locations = tmpLocations;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.choose_language),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed:(currentLocale != "it")? () => handleLangChange("it"): null,
                  child: Text("Italiano")
                ),
                ElevatedButton(
                  onPressed:(currentLocale != "en")? () => handleLangChange("en") : null,
                  child: Text("English")
                ),
              ],
            ),
            SizedBox(height: 32),

            Text(AppLocalizations.of(context)!.choose_timezone),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return [];
                }
                return locations.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                selectedTimeZone = selection;
              },
            )
          ],
        ),
      ),
    );
  }

  handleLangChange(String langCode){
    App.setLocale(context, Locale(langCode));
    setState(() {
      currentLocale = langCode;
    });
  }

}