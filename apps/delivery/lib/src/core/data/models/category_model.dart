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

import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryModel extends Equatable {
  final CategoryPlainModel categoryDetails;
  final CategoryModel? subCategory;

  CategoryModel({
    required this.categoryDetails,
    this.subCategory,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryDetails == other.categoryDetails &&
          subCategory == other.subCategory;

  @override
  int get hashCode =>
      super.hashCode ^ categoryDetails.hashCode ^ subCategory.hashCode;

  @override
  List<Object?> get props => [categoryDetails, subCategory];

  @override
  bool get stringify => true;

  static Iterable<CategoryPlainModel> allCategoryDetails(
      CategoryModel? model) sync* {
    yield model!.categoryDetails;
    if (model.subCategory != null) {
      yield* allCategoryDetails(model.subCategory!);
    }
  }

  static Iterable<String> allLocalizedNames(
    CategoryModel model,
    Locale currentLocale,
  ) sync* {
    yield model.categoryDetails.getName(currentLocale);
    yield* allLocalizedNames(model.subCategory!, currentLocale);
  }

  static Iterable<String> allIds(CategoryModel model) sync* {
    yield model.categoryDetails.id;
    yield* allIds(model.subCategory!);
  }

  static CategoryModel appendCategory(
      CategoryModel? model, CategoryPlainModel details) {
    if (model == null) {
      return CategoryModel(categoryDetails: details, subCategory: null);
    }
    return CategoryModel(
      categoryDetails: model.categoryDetails,
      subCategory: appendCategory(model.subCategory, details),
    );
  }

  static CategoryModel? changeCategory(
      CategoryModel? model, int id, CategoryPlainModel details) {
    if (model == null) return null;
    if (id == 0) {
      return CategoryModel(categoryDetails: details, subCategory: null);
    }
    return CategoryModel(
        categoryDetails: model.categoryDetails,
        subCategory: changeCategory(model.subCategory, id - 1, details));
  }
}
