import 'package:bottleshop_admin/src/models/localized_model.dart';
import 'package:flutter/material.dart';

@immutable
class UnitModel {
  static const String abbreviationField = 'abbreviation';
  static const String unitField = 'unit';
  static const String localizedAbbreviationField = 'localized_abbreviation';
  static const String localizedUnitField = 'localized_unit';

  final String id;
  final String abbreviation;
  final String unit;
  final LocalizedModel localizedAbbreviation;
  final LocalizedModel localizedUnit;

  const UnitModel({
    required this.id,
    required this.abbreviation,
    required this.unit,
    required this.localizedAbbreviation,
    required this.localizedUnit,
  });

  UnitModel.fromJson(Map<String, dynamic> json, this.id)
      : abbreviation = json[abbreviationField] as String,
        unit = json[unitField] as String,
        localizedAbbreviation = LocalizedModel.fromJson(
            json[localizedAbbreviationField] as Map<String, dynamic>),
        localizedUnit = LocalizedModel.fromJson(
            json[localizedUnitField] as Map<String, dynamic>);

  @override
  bool operator ==(other) =>
      other is UnitModel &&
      other.id == id &&
      other.abbreviation == abbreviation &&
      other.unit == unit &&
      other.localizedAbbreviation == localizedAbbreviation &&
      other.localizedUnit == localizedUnit;

  @override
  int get hashCode =>
      id.hashCode ^
      abbreviation.hashCode ^
      unit.hashCode ^
      localizedAbbreviation.hashCode ^
      localizedUnit.hashCode;
}
