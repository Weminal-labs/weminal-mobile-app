import 'dart:convert';

import 'UserModel.dart';

ReplyModel replyModelFromJson(String str) => ReplyModel.fromJson(json.decode(str));

String replyModelToJson(ReplyModel data) => json.encode(data.toJson());

class ReplyModel {
  UserModel user;
  String content;
  int likes;

  ReplyModel({
    required this.user,
    required this.content,
    required this.likes,
  });

  ReplyModel copyWith({
    UserModel? user,
    String? content,
    int? likes,
  }) =>
      ReplyModel(
        user: user ?? this.user,
        content: content ?? this.content,
        likes: likes ?? this.likes,
      );

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
    user: UserModel.fromJson(json["UserModel"]),
    content: json["content"],
    likes: json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "UserModel": user.toJson(),
    "content": content,
    "likes": likes,
  };
}
