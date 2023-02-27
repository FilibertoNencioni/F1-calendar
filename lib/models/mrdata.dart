
import 'package:f1_calendar/models/calendar.dart';
import 'package:f1_calendar/models/season.dart';

class MRData {
  String? xmlns;
  String? series;
  String? url;
  String? limit;
  String? offset;
  String? total;
  RaceTable? raceTable;
  SeasonTable? seasonTable;


  MRData({
    this.xmlns,
    this.series,
    this.url,
    this.limit,
    this.offset,
    this.total,
    this.raceTable,
    this.seasonTable
  });

  MRData.fromJson(Map<String, dynamic> json) {
    xmlns = json['xmlns'];
    series = json['series'];
    url = json['url'];
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
    raceTable = json['RaceTable'] != null
        ? RaceTable.fromJson(json['RaceTable'])
        : null;
    seasonTable = json['SeasonTable'] != null
        ? SeasonTable.fromJson(json['SeasonTable'])
        : null;
  }

}