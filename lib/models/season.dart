import 'package:f1_calendar/models/mrdata.dart';

class SeasonData {
  MRData mRData;

  SeasonData({required this.mRData});

  factory SeasonData.fromJson(Map<String, dynamic> json) {
    return SeasonData(
      mRData: MRData.fromJson(json['MRData'])
    );
  }
}

class SeasonTable {
  List<String> seasons;

  SeasonTable({required this.seasons});

  factory SeasonTable.fromJson(Map<String, dynamic> json) {
    return SeasonTable(
      seasons: List<String>.from(json['Seasons'].map((x) => x["season"]))
    );
  }

}

