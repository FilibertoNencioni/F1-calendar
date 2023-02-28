import 'package:f1_calendar/page_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageHandler(),
      builder: EasyLoading.init(),
    );
  }
}
