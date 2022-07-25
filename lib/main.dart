import 'dart:convert';

import 'package:f1_calendar/manage_calendar.dart';
import 'package:f1_calendar/models/Calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("F1 Calendar"),
      ),
      body: HomePageBody(),
    );
  }
}

Future<Calendar> fetchRaces() async {
  final response =
      await http.get(Uri.parse('https://ergast.com/api/f1/2022.json'));

  if (response.statusCode == 200) {
    return Calendar.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        ElevatedButton(
          child: Text("Get 2022 races"),
          onPressed: () => fetchRaces(),
        ),
        ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarsPage())),
            child: Text("TimeZone"))
      ],
    ));
  }
}
