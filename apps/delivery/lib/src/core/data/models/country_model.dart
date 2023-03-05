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
import 'package:flutter/material.dart';

@immutable
class CountryModel extends Equatable {
  static const String nameField = 'name';
  static const String flagField = 'flag';

  // static const String regionField = 'region';
  static const String localizedNameField = 'localizedName';
  static const String localizedRegionField = 'localizedRegion';

  final String id;
  final String? _name;
  final String? flagUrl;

  // final String region;
  final LocalizedModel? _localizedName;

  // final LocalizedModel localizedRegion;

  String? getName(LanguageMode lang) {
    switch (lang) {
      case LanguageMode.en:
        return _name;
      case LanguageMode.sk:
        return _localizedName!.slovak;
    }
  }

  const CountryModel({
    required this.id,
    required this.flagUrl,
    // @required this.region,
    // @required this.localizedRegion,
    required LocalizedModel localizedName,
    required String name,
  })  : _name = name,
        _localizedName = localizedName;

  CountryModel.fromMap(this.id, Map<String, dynamic> data)
      : _name = data[nameField],
        // region = data[regionField],
        flagUrl = data[flagField],
        _localizedName = data[localizedNameField] != null
            ? LocalizedModel.fromMap(data[localizedNameField])
            : null;

  // localizedRegion = data[localizedRegionField] != null
  //     ? LocalizedModel.fromMap(data[localizedRegionField])
  //     : null;

  @override
  List<Object?> get props {
    return [
      id,
      _name,
      // region,
      flagUrl,
      _localizedName,
      // localizedRegion,
    ];
  }

  @override
  bool get stringify => true;
}
