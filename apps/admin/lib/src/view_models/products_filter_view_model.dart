import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsFilterProvider = ChangeNotifierProvider<ProductsFilterViewModel>(
  (_) => ProductsFilterViewModel(),
);

class ProductsFilterViewModel extends ChangeNotifier {
  RangeValues? _priceRange =
      RangeValues(0, Constants.filterMaxPrice.toDouble());
  RangeValues? _alcoholRange =
      RangeValues(0, Constants.filterMaxAlcohol.toDouble());
  RangeValues? _inStockCountRange =
      RangeValues(0, Constants.filterMaxStock.toDouble());
  RangeValues? _discountRange =
      RangeValues(0, Constants.filterMaxDiscount.toDouble());
  int? _categoryId = 0;
  int? _countryId = 0;

  RangeValues get priceRange => _priceRange!;
  RangeValues get alcoholRange => _alcoholRange!;
  RangeValues? get inStockCountRange => _inStockCountRange;
  RangeValues? get discountRange => _discountRange;
  int? get countryId => _countryId;
  int? get categoryId => _categoryId;

  set priceRange(RangeValues value) {
    if (value.start.round() == 0 &&
        value.end.round() == Constants.filterMaxPrice) {
      _priceRange = null;
    } else {
      _priceRange = value;
    }
    notifyListeners();
  }

  set alcoholRange(RangeValues value) {
    if (value.start.round() == 0 &&
        value.end.round() == Constants.filterMaxAlcohol) {
      _alcoholRange = null;
    } else {
      _alcoholRange = value;
    }
    notifyListeners();
  }

  set inStockCountRange(RangeValues? value) {
    if (_inStockCountRange!.start.round() == 0 &&
        _inStockCountRange!.end.round() == Constants.filterMaxStock) {
      _inStockCountRange = null;
    } else {
      _inStockCountRange = value;
    }
    notifyListeners();
  }

  set discountRange(RangeValues? value) {
    if (_discountRange!.start.round() == 0 &&
        _discountRange!.end.round() == Constants.filterMaxDiscount) {
      _discountRange = null;
    } else {
      _discountRange = value;
    }
    notifyListeners();
  }

  set countryId(int? id) {
    _countryId = id;
    notifyListeners();
  }

  set categoryId(int? id) {
    _categoryId = id;
    notifyListeners();
  }

  void resetPriceRange() {
    _priceRange = null;
    notifyListeners();
  }

  void resetAlcoholRange() {
    _alcoholRange = null;
    notifyListeners();
  }

  void resetInStockCountRange() {
    _inStockCountRange = null;
    notifyListeners();
  }

  void resetDiscountRange() {
    _discountRange = null;
    notifyListeners();
  }

  void resetCategoryId() {
    _categoryId = null;
    notifyListeners();
  }

  void resetCountryId() {
    _countryId = null;
    notifyListeners();
  }
}
