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
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UnitModel extends Equatable {
  static const String abbreviationField = 'abbreviation';
  static const String unitField = 'unit';
  static const String localizedAbbreviationField = 'localized_abbreviation';
  static const String localizedUnitField = 'localized_unit';

  final String id;
  final String? _abbreviation;
  final String? _unit;
  final LocalizedModel _localizedAbbreviation;
  final LocalizedModel _localizedUnit;

  String? getUnitName(LanguageMode lang) {
    switch (lang) {
      case LanguageMode.en:
        return _unit;
      case LanguageMode.sk:
        return _localizedUnit.slovak;
    }
  }

  String? getUnitAbbreviation(LanguageMode lang) {
    switch (lang) {
      case LanguageMode.en:
        return _abbreviation;
      case LanguageMode.sk:
        return _localizedAbbreviation.slovak;
    }
  }

  const UnitModel({
    required this.id,
    required String abbreviation,
    required String unit,
    required LocalizedModel localizedAbbreviation,
    required LocalizedModel localizedUnit,
  })  : _abbreviation = abbreviation,
        _unit = unit,
        _localizedAbbreviation = localizedAbbreviation,
        _localizedUnit = localizedUnit;

  UnitModel.fromMap(this.id, Map<String, dynamic> data)
      : _abbreviation = data[abbreviationField],
        _unit = data[unitField],
        _localizedAbbreviation =
            LocalizedModel.fromMap(data[localizedAbbreviationField]),
        _localizedUnit = LocalizedModel.fromMap(data[localizedUnitField]);

  @override
  List<Object?> get props {
    return [
      id,
      _abbreviation,
      _unit,
      _localizedUnit,
      _localizedAbbreviation,
    ];
  }
}
