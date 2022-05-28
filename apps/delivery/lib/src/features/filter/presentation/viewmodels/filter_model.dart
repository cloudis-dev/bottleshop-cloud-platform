// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/core/utils/math_utils.dart';
import 'package:delivery/src/features/products/data/models/filter_query.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterConstants {
  FilterConstants._();

  static const int minAlcohol = 0;
  static const int maxAlcohol = 100;
  static const int alcoholDivisions = maxAlcohol - minAlcohol;

  static RangeValues get defaultAlcoholRange => RangeValues(
        minAlcohol.toDouble(),
        maxAlcohol.toDouble(),
      );

  static const int minQuantity = 0;
  static const int maxQuantity = 20;
  static const int quantityDivisions = maxQuantity - minQuantity;

  static const int minVolume = 0;
  static const int maxVolume = 5;

  static RangeValues get defaultVolumeRange => RangeValues(
        minVolume.toDouble(),
        maxVolume.toDouble(),
      );

  // .1 increments
  static const int volumeDivisions = (maxVolume - minVolume) * 10;

  static bool isVolumeMax(double value) => MathUtils.approximately(
        value,
        FilterConstants.maxVolume.toDouble(),
      );

  static const int minPrice = 0;
  static const int maxPrice = 200;

  static RangeValues get defaultPriceRange => RangeValues(
        minPrice.toDouble(),
        maxPrice.toDouble(),
      );

  static const int priceDivisions = (maxPrice - minPrice) ~/ 5;

  static bool isPriceMax(double value) => MathUtils.approximately(
        value,
        FilterConstants.maxPrice.toDouble(),
      );

  static const bool defaultIsSpecialEdition = false;

  static List<CountryModel> get defaultCountries => List.unmodifiable([]);

  static const int defaultAge = 0;
  static const int minAge = defaultAge;

  static int get defaultYear => DateTime.now(l10n.year;

  static int get maxYear => defaultYear;

  static List<String> get defaultExtraCategories => List.unmodifiable([]);
}

@immutable
class FilterModel extends Equatable {
  final RangeValues alcoholRange;
  final int minQuantity;
  final RangeValues volumeRange;

  /// This is price with VAT.
  final RangeValues priceRange;
  final bool isSpecialEdition;

  final List<CountryModel?> _countries;

  /// This is for toggling between age/year filter
  final bool isFilterByAge;
  final int minAge;
  final int maxYear;

  final List<String?> _enabledExtraCategoriesIds;

  List<CountryModel> get countries => List.unmodifiable(_countries);

  List<String> get enabledExtraCategoriesIds =>
      List.unmodifiable(_enabledExtraCategoriesIds);

  int get minAlcohol => alcoholRange.start.round();

  int get maxAlcohol => alcoholRange.end.round();

  bool get isAlcoholActive =>
      minAlcohol != FilterConstants.minAlcohol ||
      maxAlcohol != FilterConstants.maxAlcohol;

  bool get isQuantityActive => minQuantity != FilterConstants.minQuantity;

  bool get isVolumeActive =>
      !MathUtils.approximately(
        volumeRange.start,
        FilterConstants.minVolume.toDouble(),
      ) ||
      !MathUtils.approximately(
        volumeRange.end,
        FilterConstants.maxVolume.toDouble(),
      );

  bool get isPriceActive =>
      !MathUtils.approximately(
        priceRange.start,
        FilterConstants.minPrice.toDouble(),
      ) ||
      !MathUtils.approximately(
        priceRange.end,
        FilterConstants.maxPrice.toDouble(),
      );

  bool get isSpecialEditionActive =>
      isSpecialEdition != FilterConstants.defaultIsSpecialEdition;

  bool get isCountriesActive => _countries.isNotEmpty;

  bool get isAgeActive => minAge != FilterConstants.defaultAge;

  bool get isYearActive => maxYear != FilterConstants.defaultYear;

  bool get isExtraCategoriesActive => _enabledExtraCategoriesIds.isNotEmpty;

  bool get isAnyFilterActive =>
      isAlcoholActive ||
      isQuantityActive ||
      isVolumeActive ||
      isPriceActive ||
      isSpecialEditionActive ||
      isCountriesActive ||
      isAgeActive ||
      isYearActive ||
      isExtraCategoriesActive;

  FilterModel({
    required this.alcoholRange,
    required this.minQuantity,
    required this.volumeRange,
    required this.priceRange,
    required this.isSpecialEdition,
    required List<CountryModel?> countries,
    required int minAge,
    required int maxYear,
    required this.isFilterByAge,
    required List<String?> enabledExtraCategoriesIds,
  })  : _countries = countries,
        _enabledExtraCategoriesIds = enabledExtraCategoriesIds,
        minAge = isFilterByAge ? minAge : FilterConstants.defaultAge,
        maxYear = isFilterByAge ? FilterConstants.defaultYear : maxYear;

  FilterModel.empty()
      : alcoholRange = FilterConstants.defaultAlcoholRange,
        minQuantity = FilterConstants.minQuantity,
        volumeRange = FilterConstants.defaultVolumeRange,
        priceRange = FilterConstants.defaultPriceRange,
        isSpecialEdition = FilterConstants.defaultIsSpecialEdition,
        _countries = FilterConstants.defaultCountries,
        minAge = FilterConstants.defaultAge,
        maxYear = FilterConstants.defaultYear,
        _enabledExtraCategoriesIds = FilterConstants.defaultExtraCategories,
        isFilterByAge = true;

  @override
  List<Object> get props => [
        alcoholRange,
        minQuantity,
        volumeRange,
        priceRange,
        isSpecialEdition,
        _countries,
        minAge,
        maxYear,
        isFilterByAge,
        _enabledExtraCategoriesIds,
      ];

  FilterModel clearedAlcoholFilter() {
    return copyWith(alcoholRange: FilterConstants.defaultAlcoholRange);
  }

  FilterModel clearedQuantityFilter() {
    return copyWith(minQuantity: FilterConstants.minQuantity);
  }

  FilterModel clearedVolumeFilter() {
    return copyWith(volumeRange: FilterConstants.defaultVolumeRange);
  }

  FilterModel clearedPriceFilter() {
    return copyWith(priceRange: FilterConstants.defaultPriceRange);
  }

  FilterModel clearedSpecialEditionFilter() {
    return copyWith(isSpecialEdition: FilterConstants.defaultIsSpecialEdition);
  }

  FilterModel clearedCountriesFilter() {
    return copyWith(countries: FilterConstants.defaultCountries);
  }

  FilterModel clearedAgeFilter() {
    return copyWith(minAge: FilterConstants.defaultAge);
  }

  FilterModel clearedYearFilter() {
    return copyWith(maxYear: FilterConstants.defaultYear);
  }

  FilterModel clearedExtraCategoriesFilter() {
    return copyWith(
        enabledExtraCategoriesIds: FilterConstants.defaultExtraCategories);
  }

  FilterQuery getQuery(
    UnitModel literUnit, {
    CategoryPlainModel? onlyCategory,
  }) {
    return FilterQuery(
      FilterLogicOp.and,
      [
        SingleLogicOpQuery(
          FilterLogicOp.and,
          [
            if (onlyCategory != null)
              FilterFieldQuery(
                ProductModel.categoryRefsField,
                facet: onlyCategory.id,
              ),
            if (isAlcoholActive)
              FilterFieldQuery(
                ProductModel.alcoholField,
                range: alcoholRange,
              ),
            if (isQuantityActive)
              FilterFieldQuery(
                ProductModel.countField,
                gte: minQuantity.toString(),
              ),
            if (isVolumeActive) ...[
              FilterFieldQuery(
                ProductModel.unitsTypeRefField,
                facet: literUnit.id,
              ),
              if (FilterConstants.isVolumeMax(volumeRange.end))
                FilterFieldQuery(
                  ProductModel.unitsCountField,
                  gte: FormattingUtils.getVolumeNumberString(volumeRange.start),
                )
              else
                FilterFieldQuery(
                  ProductModel.unitsCountField,
                  range: volumeRange,
                ),
            ],
            if (isPriceActive) ...[
              if (FilterConstants.isPriceMax(priceRange.end))
                FilterFieldQuery(
                  ProductModel.priceNoVatField,
                  gte: FormattingUtils.getPriceNumberString(
                    priceRange.start / ProductModel.vatMultiplier,
                  ),
                )
              else
                FilterFieldQuery(
                  ProductModel.priceNoVatField,
                  range: RangeValues(
                    priceRange.start / ProductModel.vatMultiplier,
                    priceRange.end / ProductModel.vatMultiplier,
                  ),
                )
            ],
            if (isSpecialEditionActive)
              FilterFieldQuery(
                ProductModel.isSpecialEditionField,
                eq: (isSpecialEdition ? 1 : 0l10n.toString(),
              ),
            if (isAgeActive)
              FilterFieldQuery(
                ProductModel.ageField,
                gte: minAge.toString(),
              ),
            if (isYearActive)
              FilterFieldQuery(
                ProductModel.yearField,
                lte: maxYear.toString(),
              ),
          ],
        ),
        if (isExtraCategoriesActive)
          SingleLogicOpQuery(
            FilterLogicOp.or,
            _enabledExtraCategoriesIds
                .map(
                  (e) => FilterFieldQuery(
                    ProductModel.categoryRefsField,
                    facet: e,
                  ),
                )
                .toList(),
          ),
        if (isCountriesActive)
          SingleLogicOpQuery(
            FilterLogicOp.or,
            countries
                .map(
                  (e) => FilterFieldQuery(
                    ProductModel.countryRefField,
                    facet: e.id,
                  ),
                )
                .toList(),
          )
      ],
    );
  }

  FilterModel copyWith({
    RangeValues? alcoholRange,
    int? minQuantity,
    RangeValues? volumeRange,
    RangeValues? priceRange,
    bool? isSpecialEdition,
    List<CountryModel?>? countries,
    bool? isFilterByAge,
    int? minAge,
    int? maxYear,
    List<String?>? enabledExtraCategoriesIds,
  }) {
    if ((alcoholRange == null || identical(alcoholRange, this.alcoholRange)) &&
        (minQuantity == null || identical(minQuantity, this.minQuantity)) &&
        (volumeRange == null || identical(volumeRange, this.volumeRange)) &&
        (priceRange == null || identical(priceRange, this.priceRange)) &&
        (isSpecialEdition == null ||
            identical(isSpecialEdition, this.isSpecialEdition)) &&
        (countries == null || identical(countries, _countries)) &&
        (isFilterByAge == null ||
            identical(isFilterByAge, this.isFilterByAge)) &&
        (minAge == null || identical(minAge, this.minAge)) &&
        (maxYear == null || identical(maxYear, this.maxYear)) &&
        (enabledExtraCategoriesIds == null ||
            identical(enabledExtraCategoriesIds, _enabledExtraCategoriesIds))) {
      return this;
    }

    return FilterModel(
      alcoholRange: alcoholRange ?? this.alcoholRange,
      minQuantity: minQuantity ?? this.minQuantity,
      volumeRange: volumeRange ?? this.volumeRange,
      priceRange: priceRange ?? this.priceRange,
      isSpecialEdition: isSpecialEdition ?? this.isSpecialEdition,
      countries: countries ?? _countries,
      isFilterByAge: isFilterByAge ?? this.isFilterByAge,
      minAge: minAge ?? this.minAge,
      maxYear: maxYear ?? this.maxYear,
      enabledExtraCategoriesIds:
          enabledExtraCategoriesIds ?? _enabledExtraCategoriesIds,
    );
  }
}
