import 'dart:convert';

Host hostFromJson(String str) => Host.fromJson(json.decode(str));

String hostToJson(Host data) => json.encode(data.toJson());

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
