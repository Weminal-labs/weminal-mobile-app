import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  LocationClass location;

  Location({
    required this.location,
  });

  Location copyWith({
    LocationClass? location,
  }) =>
      Location(
        location: location ?? this.location,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        location: LocationClass.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
      };
}

class LocationClass {
  String name;

  LocationClass({
    required this.name,
  });

  LocationClass copyWith({
    String? name,
  }) =>
      LocationClass(
        name: name ?? this.name,
      );

  factory LocationClass.fromJson(Map<String, dynamic> json) => LocationClass(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
