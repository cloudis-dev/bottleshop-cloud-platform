import 'package:flutter/material.dart';

import 'category_plain_model.dart';

@immutable
class CategoriesTreeModel {
  static const String subcategoriesField = 'subCategories';
  static const String subcategoriesRefsField = 'subcategories_refs';
  static const String isMainCategoryField = 'is_main_category';

  final CategoryPlainModel categoryDetails;
  final List<CategoriesTreeModel> subCategories;

  CategoriesTreeModel.fromDocumentsMap(
    Map<String, dynamic> documentJson,
    String documentId,
    Map<String, Map<String, dynamic>?> documentIdsToData,
  )   : categoryDetails = CategoryPlainModel.fromJson(documentJson, documentId),
        subCategories = List.unmodifiable(
          _parseSubcategoriesNew(documentJson, documentIdsToData).toList()
            ..sort((a, b) => a.categoryDetails.localizedName.local
                .toLowerCase()
                .compareTo(
                    b.categoryDetails.localizedName.local.toLowerCase())),
        );

  static Iterable<CategoriesTreeModel> _parseSubcategoriesNew(
    Map<String, dynamic> documentJson,
    Map<String, Map<String, dynamic>?> documentIdsToData,
  ) sync* {
    if (!documentJson.containsKey(subcategoriesRefsField)) return;
    for (var i = 0; i < documentJson[subcategoriesRefsField].length; i++) {
      final documentId = documentJson[subcategoriesRefsField][i].id;
      yield CategoriesTreeModel.fromDocumentsMap(
        documentIdsToData[documentId]!,
        documentId,
        documentIdsToData,
      );
    }
  }
}
