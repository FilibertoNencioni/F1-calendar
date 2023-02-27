import 'package:f1_calendar/core/components/my_year_picker.dart';
import 'package:f1_calendar/core/services/ergast.service.dart';
import 'package:flutter/material.dart';

class NewPage extends StatefulWidget{
  const NewPage({Key? key}) : super(key: key);

  @override
  NewPageState createState() =>NewPageState();
}

class NewPageState extends State{
  List<String> seasons = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
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
      appBar: AppBar(title: Text('test')),
      body: Column(
        children: [
          const Text("Esempio"),
          MyYearPicker(
            label: 'Season',
            startDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.first)) : DateTime.now(), 
            endDate: (seasons.isNotEmpty)? DateTime(int.parse(seasons.last)) : DateTime.now(), 
            selectedDate: selectedDate, 
            onChanged: (d) => handleYearPickerChange(d), 
          )
        ]
      ),
    );
  }

  handleYearPickerChange(DateTime d){
    setState(() {
      selectedDate = d;
    });
  }

}
