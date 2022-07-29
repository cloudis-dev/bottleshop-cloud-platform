import 'package:flutter/material.dart';

@immutable
class AdminUserModel {
  static const String nickField = 'nick';
  static const String emailField = 'email';

  final String uid;
  final String nick;
  final String email;

  AdminUserModel({
    required this.uid,
    required this.nick,
    required this.email,
  });

  AdminUserModel.fromJson(Map<String, dynamic> json, this.uid)
      : email = json[emailField],
        nick = json[nickField];

  Map<String, dynamic> toFirebaseJson() => {
        nickField: nick,
        emailField: email,
      };

  @override
  bool operator ==(other) =>
      other is AdminUserModel &&
      other.uid == uid &&
      other.nick == nick &&
      other.email == email;

  @override
  int get hashCode => uid.hashCode ^ nick.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'AdminUserModel{uid: $uid, nick: $nick, email: $email}';
  }
}
