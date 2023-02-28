import 'package:f1_calendar/models/circuit.dart';
import 'package:f1_calendar/models/mrdata.dart';

class CalendarData {
  MRData mRData;

  CalendarData({required this.mRData});

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      mRData: MRData.fromJson(json['MRData'])
    );
  }
}

class RaceTable {
  String season;
  List<Races> races;

  RaceTable({required this.season, required this.races});

  factory RaceTable.fromJson(Map<String, dynamic> json) {
    return RaceTable(
      season: json['season'],
      races: List<Races>.from((json['Races'].map((race)=>Races.fromJson(race))))
    );
  }

}

class Races {
  String season;
  String round;
  String url;
  String raceName;
  Circuit circuit;
  String date;
  String time;
  RaceEvent? firstPractice;
  RaceEvent? secondPractice;
  RaceEvent? thirdPractice;
  RaceEvent? qualifying;
  RaceEvent? sprint;

  Races({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.circuit,
    required this.date,
    required this.time,
    this.firstPractice,
    this.secondPractice,
    this.thirdPractice,
    this.qualifying,
    this.sprint
  });

  factory Races.fromJson(Map<String, dynamic> json) {
    return Races(
      season: json['season'],
      round: json['round'],
      url: json['url'],
      raceName: json['raceName'],
      circuit: Circuit.fromJson(json['Circuit']),
      date: json['date'],
      time: json['time'],
      firstPractice: json['FirstPractice'] != null? RaceEvent.fromJson(json['FirstPractice']): null,
      secondPractice: json['SecondPractice'] != null? RaceEvent.fromJson(json['SecondPractice']): null,
      thirdPractice: json['ThirdPractice'] != null? RaceEvent.fromJson(json['ThirdPractice']) : null,
      qualifying: json['ThirdPractice'] != null? RaceEvent.fromJson(json['Qualifying']): null,
      sprint: json['Sprint'] != null ? RaceEvent.fromJson(json['Sprint']) : null
    );
  }
}

class RaceEvent {
  String date;
  String time;

  RaceEvent({required this.date, required this.time});

  factory RaceEvent.fromJson(Map<String, dynamic> json) {
    return RaceEvent(
      date: json['date'],
      time: json['time']
    );

  }


}
