import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/common_data_state.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:delivery/src/features/categories/data/services/db_service.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

class CommonDataService with NetworkLoggy {
  final Locale currentLocale;

  static CommonDataService? _instance;

  CommonDataService._internal(this.currentLocale) {
    _instance = this;
  }

  factory CommonDataService(Locale currentLocale) =>
      _instance ?? CommonDataService._internal(currentLocale);

  Future<List<CountryModel>> getCountries() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.countriesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => CountryModel.fromMap(e.key, e.value))
        .toList();
  }

  Future<List> getCategories() async {
    var categoriesData = await fetchCategories(currentLocale);
    categoriesData.sort((a, b) => SortingUtil.categoryCompare(
        a.categoryDetails, b.categoryDetails, currentLocale));
    return categoriesData;
  }

  Future<List<UnitModel>> getUnits() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.unitsCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data)));
    return docsMap.entries
        .map((e) => UnitModel.fromMap(e.key, e.value()))
        .toList();
  }

  Future<List<OrderTypeModel>> getOrderTypes() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.orderTypesCollection)
        .orderBy('listing_order_id')
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => OrderTypeModel.fromMap(e.key, e.value))
        .toList();
  }

  Future<CommonDataState> fetchAll() async {
    try {
      final data = await Future.wait([
        getCategories(),
        getCountries(),
        getOrderTypes(),
        getUnits(),
      ]);
      final categories = data[0] as List<CategoriesTreeModel>;
      final countries = data[1] as List<CountryModel>;
      final orderTypes = data[2] as List<OrderTypeModel>;
      final units = data[3] as List<UnitModel>;
      return CommonDataState(
          countries: countries,
          categories: categories,
          orderTypes: orderTypes,
          units: units);
    } catch (err, stack) {
      loggy.error('failed to fetch common data', err, stack);
      return CommonDataState.empty();
    }
  }
}
