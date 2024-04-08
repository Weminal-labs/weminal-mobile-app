import 'dart:convert';
import 'ReplyModel.dart';
import 'UserModel.dart';

PostModel postFromJson(String str) => PostModel.fromJson(json.decode(str));

String postToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String title;
  String content;
  List<String> images;
  UserModel userModel;
  List<ReplyModel> replies;

  PostModel({
    required this.title,
    required this.content,
    required this.images,
    required this.userModel,
    required this.replies,
  });

  PostModel copyWith({
    String? title,
    String? content,
    List<String>? images,
    UserModel? userModel,
    List<ReplyModel>? replies,
  }) =>
      PostModel(
        title: title ?? this.title,
        content: content ?? this.content,
        images: images ?? this.images,
        userModel: userModel ?? this.userModel,
        replies: replies ?? this.replies,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    title: json["title"],
    content: json["content"],
    images: List<String>.from(json["images"].map((x) => x)),
    userModel: UserModel.fromJson(json["User_Model"]),
    replies: List<ReplyModel>.from(json["Replies"].map((x) => ReplyModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "images": List<dynamic>.from(images.map((x) => x)),
    "User_Model": userModel.toJson(),
    "Replies": List<dynamic>.from(replies.map((x) => x.toJson())),
  };
}