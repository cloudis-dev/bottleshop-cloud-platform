import 'package:bottleshop_admin/src/core/data/models/localized_model.dart';
import 'package:flutter/material.dart';

@immutable
class CountryModel {
  static const String nameField = 'name';
  static const String flagField = 'flag';
  static const String localizedNameField = 'localizedName';

  final String id;
  final String name;
  final String? flagUrl;
  final LocalizedModel localizedName;

  const CountryModel({
    required this.id,
    required this.flagUrl,
    required this.localizedName,
    required this.name,
  });

  CountryModel.fromJson(Map<String, dynamic> json, this.id)
      : name = json[nameField],
        flagUrl = json[flagField],
        localizedName = LocalizedModel.fromJson(json[localizedNameField]);

  @override
  bool operator ==(other) =>
      other is CountryModel &&
      other.id == id &&
      other.name == name &&
      other.flagUrl == flagUrl &&
      other.localizedName == localizedName;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ flagUrl.hashCode ^ localizedName.hashCode;
}
