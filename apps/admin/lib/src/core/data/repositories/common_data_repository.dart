import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/core/data/models/country_model.dart';
import 'package:bottleshop_admin/src/core/data/models/unit_model.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommonDataRepository {
  Stream<String?> minVersionStream() {
    return FirebaseFirestore.instance
        .collection(Constants.versionConstraintsCollection)
        .doc('admin')
        .snapshots()
        .map((event) => event.get('min_version'));
  }

  Future<List<CountryModel>> countries() async {
    final docs = await FirebaseFirestore.instance
        .collection(Constants.countriesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => CountryModel.fromJson(e.value, e.key))
        .toList();
  }

  Future<List<CategoriesTreeModel>> categories() async {
    final docs = await FirebaseFirestore.instance
        .collection(Constants.categoriesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .where((element) =>
            element.value.containsKey(CategoriesTreeModel.isMainCategoryField))
        .map((e) =>
            CategoriesTreeModel.fromDocumentsMap(e.value, e.key, docsMap))
        .toList();
  }

  Future<List<UnitModel>> units() async {
    final docs = await FirebaseFirestore.instance
        .collection(Constants.unitsCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data)));
    return docsMap.entries
        .map((e) => UnitModel.fromJson(e.value(), e.key))
        .toList();
  }

  Future<List<OrderTypeModel>> orderTypes() async {
    final docs = await FirebaseFirestore.instance
        .collection(Constants.orderTypesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => OrderTypeModel.fromJson(e.value, e.key))
        .toList();
  }
}
