import 'package:collection/collection.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CommonDataState extends Equatable {
  final List<CountryModel> _countries;
  final List<CategoriesTreeModel> _categories;
  final List<UnitModel> _units;
  final List<OrderTypeModel> _orderTypes;

  List<CountryModel> get countries =>
      UnmodifiableListView<CountryModel>(_countries);

  List<CategoriesTreeModel> get categories =>
      UnmodifiableListView<CategoriesTreeModel>(_categories);

  List<UnitModel> get units => UnmodifiableListView<UnitModel>(_units);

  List<OrderTypeModel> get orderTypes =>
      UnmodifiableListView<OrderTypeModel>(_orderTypes);

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
      : this(
            countries: List.empty(),
            categories: List.empty(),
            units: List.empty(),
            orderTypes: List.empty());

  @override
  List<Object?> get props =>
      ['_countries', '_categories', '_units', 'orderTypes'];
}
