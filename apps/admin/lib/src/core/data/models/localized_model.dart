import 'package:flutter/material.dart';

@immutable
class LocalizedModel {
  static const String slovakField = 'sk';

  final String _slovak;

  String get local => _slovak;

  const LocalizedModel({required String slovak}) : _slovak = slovak;

  LocalizedModel.fromJson(Map<String, dynamic> json)
      : _slovak = json[slovakField];

  @override
  bool operator ==(other) =>
      other is LocalizedModel && other._slovak == _slovak;

  @override
  int get hashCode => _slovak.hashCode;
}
