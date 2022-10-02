// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.udid,
    required this.name,
    required this.number,
    required this.openToChat,
    required this.inconversation,
  });

  String udid;
  String name;
  String number;
  bool openToChat;
  bool inconversation;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        udid: json["udid"],
        name: json["name"],
        number: json["number"],
        openToChat: json["open_to_chat"],
        inconversation: json["inconversation"],
      );

  Map<String, dynamic> toJson() => {
        "udid": udid,
        "name": name,
        "number": number,
        "open_to_chat": openToChat,
        "inconversation": inconversation,
      };
}
