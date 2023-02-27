import 'package:f1_calendar/manage_calendar.dart';
import 'package:f1_calendar/pages/first_page.dart';
import 'package:f1_calendar/pages/new_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("F1 Calendar"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Test UI"),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstPage())),
            ),
            ElevatedButton(
              child: const Text("TimeZone"),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarsPage()))
            ),
            ElevatedButton(
              child: const Text('Test API'),
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPage()))
            )
          ],
        )

      ),
    );
  }
}

