import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String eventId;
  String name;
  String coverUrl;
  DateTime createdAt;
  DateTime startAt;
  DateTime endAt;
  Location location;
  String timezone;
  Ticket ticket;
  Host host;

  Event({
    required this.eventId,
    required this.name,
    required this.coverUrl,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.timezone,
    required this.ticket,
    required this.host,
  });

  Event copyWith({
    String? eventId,
    String? name,
    String? coverUrl,
    DateTime? createdAt,
    DateTime? startAt,
    DateTime? endAt,
    Location? location,
    String? timezone,
    Ticket? ticket,
    Host? host,
  }) =>
      Event(
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
        coverUrl: coverUrl ?? this.coverUrl,
        createdAt: createdAt ?? this.createdAt,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
        location: location ?? this.location,
        timezone: timezone ?? this.timezone,
        ticket: ticket ?? this.ticket,
        host: host ?? this.host,
      );

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"],
        name: json["name"],
        coverUrl: json["cover_url"],
        createdAt: DateTime.parse(json["created_at"]),
        startAt: DateTime.parse(json["start_at"]),
        endAt: DateTime.parse(json["end_at"]),
        location: Location.fromJson(json["location"]),
        timezone: json["timezone"],
        ticket: Ticket.fromJson(json["ticket"]),
        host: Host.fromJson(json["host"]),
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "name": name,
        "cover_url": coverUrl,
        "created_at": createdAt.toIso8601String(),
        "start_at": startAt.toIso8601String(),
        "end_at": endAt.toIso8601String(),
        "location": location.toJson(),
        "timezone": timezone,
        "ticket": ticket.toJson(),
        "host": host.toJson(),
      };
}

class Host {
  String apiId;
  String name;
  dynamic username;
  String avatarUrl;
  String bioShort;
  String website;
  dynamic instagramHandle;
  String linkedinHandle;
  dynamic tiktokHandle;
  String twitterHandle;
  String youtubeHandle;
  String timezone;

  Host({
    required this.apiId,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.bioShort,
    required this.website,
    required this.instagramHandle,
    required this.linkedinHandle,
    required this.tiktokHandle,
    required this.twitterHandle,
    required this.youtubeHandle,
    required this.timezone,
  });

  Host copyWith({
    String? apiId,
    String? name,
    dynamic username,
    String? avatarUrl,
    String? bioShort,
    String? website,
    dynamic instagramHandle,
    String? linkedinHandle,
    dynamic tiktokHandle,
    String? twitterHandle,
    String? youtubeHandle,
    String? timezone,
  }) =>
      Host(
        apiId: apiId ?? this.apiId,
        name: name ?? this.name,
        username: username ?? this.username,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bioShort: bioShort ?? this.bioShort,
        website: website ?? this.website,
        instagramHandle: instagramHandle ?? this.instagramHandle,
        linkedinHandle: linkedinHandle ?? this.linkedinHandle,
        tiktokHandle: tiktokHandle ?? this.tiktokHandle,
        twitterHandle: twitterHandle ?? this.twitterHandle,
        youtubeHandle: youtubeHandle ?? this.youtubeHandle,
        timezone: timezone ?? this.timezone,
      );

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        apiId: json["api_id"],
        name: json["name"],
        username: json["username"],
        avatarUrl: json["avatar_url"],
        bioShort: json["bio_short"],
        website: json["website"],
        instagramHandle: json["instagram_handle"],
        linkedinHandle: json["linkedin_handle"],
        tiktokHandle: json["tiktok_handle"],
        twitterHandle: json["twitter_handle"],
        youtubeHandle: json["youtube_handle"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "api_id": apiId,
        "name": name,
        "username": username,
        "avatar_url": avatarUrl,
        "bio_short": bioShort,
        "website": website,
        "instagram_handle": instagramHandle,
        "linkedin_handle": linkedinHandle,
        "tiktok_handle": tiktokHandle,
        "twitter_handle": twitterHandle,
        "youtube_handle": youtubeHandle,
        "timezone": timezone,
      };
}

class Location {
  String name;

  Location({
    required this.name,
  });

  Location copyWith({
    String? name,
  }) =>
      Location(
        name: name ?? this.name,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Ticket {
  dynamic price;
  bool isSoldOut;
  dynamic spotsRemaining;
  bool isNearCapacity;
  String ticketCurrency;

  Ticket({
    required this.price,
    required this.isSoldOut,
    required this.spotsRemaining,
    required this.isNearCapacity,
    required this.ticketCurrency,
  });

  Ticket copyWith({
    dynamic price,
    bool? isSoldOut,
    dynamic spotsRemaining,
    bool? isNearCapacity,
    String? ticketCurrency,
  }) =>
      Ticket(
        price: price ?? this.price,
        isSoldOut: isSoldOut ?? this.isSoldOut,
        spotsRemaining: spotsRemaining ?? this.spotsRemaining,
        isNearCapacity: isNearCapacity ?? this.isNearCapacity,
        ticketCurrency: ticketCurrency ?? this.ticketCurrency,
      );

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        price: json["price"],
        isSoldOut: json["is_sold_out"],
        spotsRemaining: json["spots_remaining"],
        isNearCapacity: json["is_near_capacity"],
        ticketCurrency: json["ticket_currency"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "is_sold_out": isSoldOut,
        "spots_remaining": spotsRemaining,
        "is_near_capacity": isNearCapacity,
        "ticket_currency": ticketCurrency,
      };
}
