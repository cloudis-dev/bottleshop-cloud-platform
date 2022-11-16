import 'dart:collection';

import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:delivery/src/features/categories/data/services/db_service.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CommonDataRepository).toString());

class CommonDataRepository with ChangeNotifier {
  final Locale currentLocale;

  static CommonDataRepository? _instance;
  String? _error;
  bool? _loading;
  List<CountryModel> _countries = [];
  List<CategoriesTreeModel> _categories = [];
  List<UnitModel> _units = [];
  List<OrderTypeModel> _orderTypes = [];

  List<CountryModel> get countries =>
      UnmodifiableListView<CountryModel>(_countries);
  List<CategoriesTreeModel> get categories =>
      UnmodifiableListView<CategoriesTreeModel>(_categories);
  List<UnitModel> get units => UnmodifiableListView<UnitModel>(_units);
  List<OrderTypeModel> get orderTypes =>
      UnmodifiableListView<OrderTypeModel>(_orderTypes);

  CommonDataRepository._internal(this.currentLocale) {
    _logger.fine('created');
    _instance = this;
    _loading = true;
  }

  factory CommonDataRepository(Locale currentLocale) =>
      _instance ?? CommonDataRepository._internal(currentLocale);

  Future<List<CountryModel>> _getCountries() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.countriesCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => CountryModel.fromMap(e.key, e.value))
        .toList();
  }

  Future<List<CategoriesTreeModel>> _getCategories() async {
    return fetchCategories(currentLocale).then(
      (value) => value
        ..sort(
          (a, b) => SortingUtil.categoryCompare(
            a.categoryDetails,
            b.categoryDetails,
            currentLocale,
          ),
        ),
    );
  }

  Future<List<UnitModel>> _getUnits() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.unitsCollection)
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data)));
    return docsMap.entries
        .map((e) => UnitModel.fromMap(e.key, e.value()))
        .toList();
  }

  Future<List<OrderTypeModel>> _getOrderTypes() async {
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

  String? get error => _error;

  bool? get isLoading => _loading;

  Future<void> fetch() async {
    try {
      final data = await Future.wait([
        _getCategories(),
        _getCountries(),
        _getOrderTypes(),
        _getUnits(),
      ]);
      _categories = data[0] as List<CategoriesTreeModel>;
      _countries = data[1] as List<CountryModel>;
      _orderTypes = data[2] as List<OrderTypeModel>;
      _units = data[3] as List<UnitModel>;
    } catch (err, stack) {
      _logger.severe('failed to fetch common data', err, stack);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
