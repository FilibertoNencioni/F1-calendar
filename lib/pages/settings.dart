import 'package:f1_calendar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget{
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>{
  String currentLocale = '';
  
  @override
  void initState() {
    App.getLocale(context).then((newLocale){
      if(newLocale != null){
        setState(() {
          currentLocale = newLocale.languageCode;
        });
      }
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