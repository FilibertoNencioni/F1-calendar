class Location {
  String lat;
  String long;
  String locality;
  String country;

  Location({required this.lat, required this.long, required this.locality, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      long: json['long'],
      locality: json['locality'],
      country: json['country']
    );
  }

}