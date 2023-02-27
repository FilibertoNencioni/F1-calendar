import 'package:flutter/material.dart';

class MyYearPicker extends StatefulWidget {
  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final void Function(DateTime) onChanged;
  
  const MyYearPicker({
    Key? key, 
    required this.label, 
    required this.startDate, 
    required this.endDate, 
    required this.selectedDate, 
    required this.onChanged,
  }) : super(key: key);
  
  @override
  MyYearPickerState createState() => MyYearPickerState();
}

class MyYearPickerState extends State<MyYearPicker>{
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.selectedDate.year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(   
      controller: controller,
      decoration: InputDecoration(
        suffixIcon:const Icon(Icons.calendar_today) ,
        labelText: widget.label
      ),
      readOnly: true,
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Seleziona una stagione"),
              content: SizedBox(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: widget.startDate,
                  lastDate: widget.endDate,

                  selectedDate: widget.selectedDate,
                  onChanged: (d) {
                    widget.onChanged(d);
                    controller.text = d.year.toString(); 
                    Navigator.of(context).pop();              
                  }
                ),
              ),
            );
          },
        );
      },
    );
  }
}