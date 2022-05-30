import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:flutter/material.dart';

Future<List<CategoriesTreeModel>> fetchCategories(Locale currentLocale) async {
  var docs = await FirebaseFirestore.instance
      .collection(FirestoreCollections.categoriesCollection)
      .get();
  final docsMap =
      Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
  return docsMap.entries
      .where((element) =>
          element.value.containsKey(CategoriesTreeModel.isMainCategoryField))
      .map((e) => CategoriesTreeModel.fromDocumentsMap(
          e.value, e.key, docsMap, currentLocale))
      .toList();
}
