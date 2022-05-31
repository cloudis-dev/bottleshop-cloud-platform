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
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:flutter/material.dart';

@immutable
class CategoriesTreeModel {
  static const String subcategoriesField = 'subCategories';
  static const String subcategoriesRefsField = 'subcategories_refs';
  static const String isMainCategoryField = 'is_main_category';

  final CategoryPlainModel categoryDetails;
  final List<CategoriesTreeModel> subCategories;

  bool get hasSubcategories => subCategories.isNotEmpty;

  CategoriesTreeModel.fromDocumentsMap(
    Map<String, dynamic> documentJson,
    String documentId,
    Map<String, Map<String, dynamic>> documentIdsToData,
    Locale currentLocale,
  )   : categoryDetails = CategoryPlainModel.fromJson(documentJson, documentId),
        subCategories = List.unmodifiable(
          _parseSubcategories(currentLocale, documentJson, documentIdsToData)
              .toList()
            ..sort(
              (a, b) => SortingUtil.categoryCompare(
                a.categoryDetails,
                b.categoryDetails,
                currentLocale,
              ),
            ),
        );

  static Iterable<CategoriesTreeModel> _parseSubcategories(
    Locale currentLocale,
    Map<String, dynamic> documentJson,
    Map<String, Map<String, dynamic>> documentIdsToData,
  ) sync* {
    if (!documentJson.containsKey(subcategoriesRefsField)) return;
    for (var i = 0; i < documentJson[subcategoriesRefsField].length; i++) {
      final documentId = documentJson[subcategoriesRefsField][i].id;
      yield CategoriesTreeModel.fromDocumentsMap(
        documentIdsToData[documentId]!,
        documentId,
        documentIdsToData,
        currentLocale,
      );
    }
  }

  static Iterable<CategoryPlainModel> getAllCategoryPlainModels(
    CategoriesTreeModel categoryTree,
  ) sync* {
    yield categoryTree.categoryDetails;
    for (var i = 0; i < categoryTree.subCategories.length; i++) {
      yield* getAllCategoryPlainModels(categoryTree.subCategories[i]);
    }
  }

  @override
  String toString() {
    return 'CategoriesTreeModel{categoryDetails: $categoryDetails, subCategories: $subCategories}';
  }
}
