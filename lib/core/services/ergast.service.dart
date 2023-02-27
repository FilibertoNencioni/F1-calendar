import 'package:f1_calendar/models/season.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/calendar.dart';

String baseUrl = 'http://ergast.com/api/f1';

Future<SeasonData> getSeasons() async {
  var jsonResponse = await http.get(
    Uri.parse('$baseUrl/seasons.json?limit=2000'), 
  );
  if (jsonResponse.statusCode == 200) {
    final jsonItems = json.decode(jsonResponse.body);
    SeasonData seasons = SeasonData.fromJson(jsonItems);
    return seasons;
  } else {
    throw Exception('Failed to load data from internet');
  }
}

  Future<CalendarData> getRaces() async {
    final response =  await http.get(Uri.parse('$baseUrl/2022.json'));

    if (response.statusCode == 200) {
      return CalendarData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }