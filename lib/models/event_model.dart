import 'dart:convert';

import 'package:weminal_app/models/ticket_model.dart';

import 'host_model.dart';
import 'location_model.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String id;
  String name;
  String coverUrl;
  String createdAt;
  String desription;
  String startAt;
  String endAt;
  Location location;
  String timezone;
  Ticket ticket;
  Host host;

  Event({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.createdAt,
    required this.desription,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.timezone,
    required this.ticket,
    required this.host,
  });

  Event copyWith({
    String? id,
    String? name,
    String? coverUrl,
    String? createdAt,
    String? description,
    String? startAt,
    String? endAt,
    Location? location,
    String? timezone,
    Ticket? ticket,
    Host? host,
  }) =>
      Event(
        id: id ?? this.id,
        name: name ?? this.name,
        coverUrl: coverUrl ?? this.coverUrl,
        createdAt: createdAt ?? this.createdAt,
        desription: description ?? this.desription,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
        location: location ?? this.location,
        timezone: timezone ?? this.timezone,
        ticket: ticket ?? this.ticket,
        host: host ?? this.host,
      );

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        name: json["name"],
        coverUrl: json["cover_url"],
        createdAt: json["created_at"],
        desription: json["desription"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        location: Location.fromJson(json["location"]),
        timezone: json["timezone"],
        ticket: Ticket.fromJson(json["ticket"]),
        host: Host.fromJson(json["host"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover_url": coverUrl,
        "created_at": createdAt,
        "desription": desription,
        "start_at": startAt,
        "end_at": endAt,
        "location": location.toJson(),
        "timezone": timezone,
        "ticket": ticket.toJson(),
        "host": host.toJson(),
      };
}
