import 'package:f1_calendar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget{
  const Settings({Key? key}) : super(key: key);

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
            SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => App.setLocale(context, Locale("it")),
                  child: Text("Italiano")
                ),
                ElevatedButton(
                  onPressed: () => App.setLocale(context, Locale("en")),
                  child: Text("English")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}