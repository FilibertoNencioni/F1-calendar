import 'package:f1_calendar/models/location.dart';

class Circuit {
  String circuitId;
  String url;
  String circuitName;
  Location location;

  Circuit({required this.circuitId, required this.url, required this.circuitName, required this.location});

  factory Circuit.fromJson(Map<String, dynamic> json) {
    return Circuit(
      circuitId: json['circuitId'],
      url: json['url'],
      circuitName: json['circuitName'],
      location: Location.fromJson(json['Location'])
    );
  }
}