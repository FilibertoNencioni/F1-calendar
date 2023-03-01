import 'package:f1_calendar/page_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    AppState? state = context.findAncestorStateOfType<AppState>();

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale.languageCode);

    state?.setState(() {
      state.appLocale = newLocale;
    });
  }

  static Future<Locale?> getLocale(BuildContext context) async{
    AppState? state = context.findAncestorStateOfType<AppState>();
    return state?.appLocale;
  }

  @override
  AppState createState()=>AppState();
}

class AppState extends State<App>{
  Locale appLocale = Locale('en');

  @override
  void initState() {
    super.initState();
    fetchLocale().then((locale) {
      setState(() {
        appLocale = locale;
      });
    });
  }

  Future<Locale> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('languageCode') ?? 'en';

    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('it'),
      ],
      locale: appLocale,
      home: const PageHandler(),
      builder: EasyLoading.init(),
    );
  }
}

/*
  To solve problem of hold press on inputs
 */
class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}