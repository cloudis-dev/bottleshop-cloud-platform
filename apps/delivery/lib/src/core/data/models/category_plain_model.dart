// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/core/data/models/localized_model.dart';
import 'package:delivery/src/core/utils/language_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryPlainModel extends Equatable {
  static const String uidField = 'uid';
  static const String localizedNameField = 'localized_name';
  static const String nameField = 'name';
  static const String extraCategoryField = 'extra';
  static const String iconNameField = 'icon_name';

  final String id;
  final String? iconName;
  final bool isExtraCategory;
  final String _name;
  final LocalizedModel _localizedName;

  String getName(Locale locale) {
    switch (LanguageUtils.parseLocale(locale)) {
      case LocaleLanguage.slovak:
        return _localizedName.slovak;
      case LocaleLanguage.english:
        return _name;
    }
  }

  const CategoryPlainModel({
    required this.id,
    required LocalizedModel localizedName,
    required String name,
    required this.isExtraCategory,
    required this.iconName,
  })  : _localizedName = localizedName,
        _name = name;

  CategoryPlainModel.fromJson(Map<String, dynamic> json, this.id)
      : _name = json[nameField],
        _localizedName = LocalizedModel.fromMap(json[localizedNameField]),
        isExtraCategory = json[extraCategoryField] ?? false,
        iconName = json[iconNameField] != null
            ? 'assets/images/${json[iconNameField]}.png'
            : null;

  Map<String, dynamic> toJson() {
    return {
      uidField: id,
      nameField: _name,
      localizedNameField: _localizedName.toJson(),
      extraCategoryField: isExtraCategory,
      iconNameField: iconName
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      iconName,
      isExtraCategory,
      _name,
      _localizedName,
    ];
  }

  @override
  bool get stringify => true;
}
