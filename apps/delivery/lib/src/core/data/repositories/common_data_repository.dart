import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:delivery/src/features/categories/data/services/db_service.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

@immutable
class CommonDataState extends Equatable {
  final List<CountryModel> _countries;
  final List<CategoriesTreeModel> _categories;
  final List<UnitModel> _units;
  final List<OrderTypeModel> _orderTypes;

  List<CountryModel> get countries => UnmodifiableListView<CountryModel>(_countries);

  List<CategoriesTreeModel> get categories => UnmodifiableListView<CategoriesTreeModel>(_categories);

  List<UnitModel> get units => UnmodifiableListView<UnitModel>(_units);

  List<OrderTypeModel> get orderTypes => UnmodifiableListView<OrderTypeModel>(_orderTypes);

  const CommonDataState({
    required List<CountryModel> countries,
    required List<CategoriesTreeModel> categories,
    required List<OrderTypeModel> orderTypes,
    required List<UnitModel> units,
  })  : _countries = countries,
        _categories = categories,
        _orderTypes = orderTypes,
        _units = units;

  CommonDataState.empty()
      : this(countries: List.empty(), categories: List.empty(), units: List.empty(), orderTypes: List.empty());

  @override
  List<Object?> get props => ['_countries', '_categories', '_units', 'orderTypes'];
}

class CommonDataRepository extends StateNotifier<AsyncValue<void>> {
  final CommonDataService dataService;
  late CommonDataState _dataState;

  CommonDataState get data => _dataState;

  CommonDataRepository({required this.dataService}) : super(const AsyncValue.data(null)) {
    _dataState = CommonDataState.empty();
  }

  Future<void> init() async {
    try {
      state = const AsyncValue.loading();
      _dataState = await dataService.fetchAll();
    } catch (e) {
      state = const AsyncValue.error('Could not fetch critical data');
    } finally {
      _dataState = CommonDataState.empty();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> refresh() async {
    try {
      state = const AsyncValue.loading();
      _dataState = CommonDataState.empty();
      _dataState = await dataService.fetchAll();
    } catch (e) {
      state = const AsyncValue.error('Could not fetch critical data');
    } finally {
      _dataState = CommonDataState.empty();
      state = const AsyncValue.data(null);
    }
  }
}

class CommonDataService with NetworkLoggy {
  final Locale currentLocale;

  static CommonDataService? _instance;

  CommonDataService._internal(this.currentLocale) {
    _instance = this;
  }

  factory CommonDataService(Locale currentLocale) => _instance ?? CommonDataService._internal(currentLocale);

  Future<List<CountryModel>> getCountries() async {
    final docs = await FirebaseFirestore.instance.collection(FirestoreCollections.countriesCollection).get();
    final docsMap = Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries.map((e) => CountryModel.fromMap(e.key, e.value)).toList();
  }

  Future<List> getCategories() async {
    var categoriesData = await fetchCategories(currentLocale);
    categoriesData.sort((a, b) => SortingUtil.categoryCompare(a.categoryDetails, b.categoryDetails, currentLocale));
    return categoriesData;
  }

  Future<List<UnitModel>> getUnits() async {
    final docs = await FirebaseFirestore.instance.collection(FirestoreCollections.unitsCollection).get();
    final docsMap = Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data)));
    return docsMap.entries.map((e) => UnitModel.fromMap(e.key, e.value())).toList();
  }

  Future<List<OrderTypeModel>> getOrderTypes() async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.orderTypesCollection)
        .orderBy('listing_order_id')
        .get();
    final docsMap = Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries.map((e) => OrderTypeModel.fromMap(e.key, e.value)).toList();
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
      return CommonDataState(countries: countries, categories: categories, orderTypes: orderTypes, units: units);
    } catch (err, stack) {
      loggy.error('failed to fetch common data', err, stack);
      return CommonDataState.empty();
    }
  }
}

final commonDataRepositoryProvider = Provider<CommonDataRepository>(
  (ref) {
    final currentLocale = ref.watch(currentLocaleProvider);
    return CommonDataRepository(dataService: CommonDataService(currentLocale));
  },
);
