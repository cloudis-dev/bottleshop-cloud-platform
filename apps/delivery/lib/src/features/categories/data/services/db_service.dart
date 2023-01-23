import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';

Future<List<CategoriesTreeModel>> fetchCategories(LanguageMode lang) async {
  var docs = await FirebaseFirestore.instance
      .collection(FirestoreCollections.categoriesCollection)
      .get();
  final docsMap =
      Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
  return docsMap.entries
      .where((element) =>
          element.value.containsKey(CategoriesTreeModel.isMainCategoryField))
      .map((e) =>
          CategoriesTreeModel.fromDocumentsMap(e.value, e.key, docsMap, lang))
      .toList();
}
