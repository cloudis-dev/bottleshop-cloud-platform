import 'package:bottleshop_admin/src/core/data/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/core/data/models/country_model.dart';
import 'package:bottleshop_admin/src/core/data/models/unit_model.dart';
import 'package:bottleshop_admin/src/core/utils/sorting_util.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class ConstantAppDataModel {
  final List<CountryModel> countries;
  final List<CategoriesTreeModel> categories;
  final List<UnitModel> units;
  final List<OrderTypeModel> orderTypes;

  ConstantAppDataModel.empty()
      : countries = List.unmodifiable([]),
        categories = List.unmodifiable([]),
        units = List.unmodifiable([]),
        orderTypes = List.unmodifiable([]);

  ConstantAppDataModel({
    required List<CountryModel> countries,
    required List<CategoriesTreeModel> categories,
    required List<UnitModel> units,
    required List<OrderTypeModel> orderTypes,
  })  : countries = List.unmodifiable(
          countries
            ..sort(
              (a, b) => SortingUtil.stringSortCompare(
                a.localizedName.local,
                b.localizedName.local,
              ),
            ),
        ),
        categories = List.unmodifiable(
          categories
            ..sort(
              (a, b) => SortingUtil.stringSortCompare(
                a.categoryDetails.localizedName.local,
                b.categoryDetails.localizedName.local,
              ),
            ),
        ),
        units = List.unmodifiable(units),
        orderTypes = List.unmodifiable(orderTypes);

  List<CategoriesTreeModel> categoriesWithoutExtraCategories() => categories
      .where((element) => !element.categoryDetails.isExtraCategory)
      .toList();

  List<CategoriesTreeModel> extraCategories() => categories
      .where((element) => element.categoryDetails.isExtraCategory)
      .toList();
}
