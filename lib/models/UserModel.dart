import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  String location;
  String bio;
  int postCount;
  int postReplies;
  int answerVerified;
  int votes;

  UserModel({
    required this.name,
    required this.location,
    required this.bio,
    required this.postCount,
    required this.postReplies,
    required this.answerVerified,
    required this.votes,
  });

  UserModel copyWith({
    String? name,
    String? location,
    String? bio,
    int? postCount,
    int? postReplies,
    int? answerVerified,
    int? votes,
  }) =>
      UserModel(
        name: name ?? this.name,
        location: location ?? this.location,
        bio: bio ?? this.bio,
        postCount: postCount ?? this.postCount,
        postReplies: postReplies ?? this.postReplies,
        answerVerified: answerVerified ?? this.answerVerified,
        votes: votes ?? this.votes,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    location: json["location"],
    bio: json["bio"],
    postCount: json["post_count"],
    postReplies: json["post_replies"],
    answerVerified: json["answer_verified"],
    votes: json["votes"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "location": location,
    "bio": bio,
    "post_count": postCount,
    "post_replies": postReplies,
    "answer_verified": answerVerified,
    "votes": votes,
  };
}
