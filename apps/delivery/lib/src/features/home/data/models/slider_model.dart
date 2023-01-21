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
import 'package:flutter/material.dart';

@immutable
class SliderModel {
  final String id;
  final String _imageUrl;
  final String _description;
  final String? _descriptionLocalized;

  final LocalizedModel? _imageUrlLocalized;

  String getImageUrl(LanguageMode lang) {
    if (_imageUrlLocalized == null) {
      return _imageUrl;
    }
    switch (lang) {
      case LanguageMode.en:
        return _imageUrl;
      case LanguageMode.sk:
        return _imageUrlLocalized!.slovak;
    }
  }

  String getDescription(LanguageMode lang) {
    if (_descriptionLocalized == null) {
      return _description;
    }
    switch (lang) {
      case LanguageMode.en:
        return _description;
      case LanguageMode.sk:
        return _descriptionLocalized!;
    }
  }

  const SliderModel({
    required this.id,
    required String imageUrl,
    required String description,
    required String descriptionLocalized,
    required LocalizedModel? imageUrlLocalized,
  })  : _imageUrlLocalized = imageUrlLocalized,
        _imageUrl = imageUrl,
        _description = description,
        _descriptionLocalized = descriptionLocalized;

  factory SliderModel.fromMap(Map<String, dynamic> data, String id) {
    return SliderModel(
      id: id,
      imageUrl: data['imageUrl'],
      description: data['description'],
      descriptionLocalized: data['description_localized'],
      imageUrlLocalized:
          data.containsKey(SliderModelFields.imageUrlLocalizedField)
              ? LocalizedModel.fromMap(
                  data[SliderModelFields.imageUrlLocalizedField])
              : null,
    );
  }
}

class SliderModelFields {
  static const String imageUrlLocalizedField = 'imageUrl_localized';
}
