import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'localized_model.dart';

@immutable
class CategoryPlainModel extends Equatable {
  static const String localizedNameField = 'localized_name';
  static const String nameField = 'name';
  static const String extraCategoryField = 'extra';

  final String id;
  final LocalizedModel localizedName;
  final String name;
  final bool isExtraCategory;

  CategoryPlainModel({
    required this.id,
    required this.localizedName,
    required this.name,
    required this.isExtraCategory,
  });

  CategoryPlainModel.fromJson(Map<String, dynamic> json, this.id)
      : name = json[nameField],
        localizedName = LocalizedModel.fromJson(json[localizedNameField]),
        isExtraCategory = json[extraCategoryField] ?? false;

  @override
  List<Object?> get props => [
        id,
        localizedName,
        name,
        isExtraCategory,
      ];
}
