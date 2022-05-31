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

import 'package:delivery/src/core/data/models/category_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/utils/language_utils.dart';
import 'package:delivery/src/features/products/data/models/flash_sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class ProductModel {
  static const double vatMultiplier = 1.20;

  // firebase json fields
  static const String nameField = 'name';
  static const String editionField = 'edition';
  static const String ageField = 'age';
  static const String yearField = 'year';
  static const String cmatField = 'cmat';
  static const String eanField = 'ean';
  static const String priceNoVatField = 'price_no_vat';
  static const String countField = 'amount';
  static const String unitsCountField = 'unit_value';
  static const String alcoholField = 'alcohol';
  static const String countryRefField = 'country_ref';
  static const String unitsTypeRefField = 'unit_ref';
  static const String descriptionSkField = 'description_sk';
  static const String descriptionEnField = 'description_en';
  static const String discountField = 'discount';
  static const String categoryRefsField = 'category_refs';
  static const String isRecommendedField = 'is_recommended';
  static const String isNewEntryField = 'is_new_entry';
  static const String isSaleField = 'is_sale';
  static const String isFlashSaleField = 'is_flash_sale';
  static const String flashSaleModelField = 'flash_sale';
  static const String thumbnailPathField = 'thumbnail_path';
  static const String imagePathField = 'image_path';
  static const String activePromoCodesCountField = 'active_promo_codes_count';
  static const String isSpecialEditionField = 'is_special_edition';

  /// This field is added by a firebase function
  static const String finalPriceSortField = '_final_price';

  /// This field is added by a firebase function
  static const String unaccentedNameSortField = '_name_sort';

  // fields after data join
  static const String categoriesField = 'categories';
  static const String unitsTypeField = 'unit';
  static const String countryField = 'country';

  final String name;
  final String? edition;
  final int? age;
  final int? year;
  final String cmat;
  final String ean;
  final double _priceNoVat;
  final int count;
  final double unitsCount;
  final UnitModel unitsType;
  final double? alcohol;
  final List<CategoryModel> _categories;
  final CountryModel country;
  final String? _descriptionSk;
  final String? _descriptionEn;
  final double? discount;
  final bool? _isRecommended;
  final bool? _isNewEntry;
  final bool? _isFlashSale;
  final bool? _isSale;
  final String? thumbnailPath;
  final String? imagePath;
  final int? activePromoCodesCount;
  final FlashSaleModel? flashSale;

  String get uniqueId => cmat;
  List<CategoryModel>? get extraCategories => _categories.skip(1).toList();
  List<CategoryModel> get allCategories => _categories;

  bool get hasAlcohol => alcohol != null;

  double get priceNoVat => double.parse(_priceNoVat.toStringAsFixed(2));

  double get priceWithVat => priceNoVat * vatMultiplier;

  double get finalPrice =>
      priceNoVat * vatMultiplier * (discount == null ? 1 : 1 - discount!);

  bool get isFlashSale => _isFlashSale ?? false;
  bool get isNewEntry => _isNewEntry ?? false;
  bool get isRecommended => _isRecommended ?? false;

  bool get isSpecialEdition => edition != null;

  String? getDescription(Locale locale) {
    switch (LanguageUtils.parseLocale(locale)) {
      case LocaleLanguage.slovak:
        return _descriptionSk;
      case LocaleLanguage.english:
        return _descriptionEn;
    }
  }

  ProductModel({
    required this.name,
    required this.edition,
    required this.age,
    required this.year,
    required this.cmat,
    required this.ean,
    required double priceNoVat,
    required this.count,
    required this.unitsCount,
    required this.unitsType,
    required this.alcohol,
    required List<CategoryModel> categories,
    required this.country,
    required String descriptionSk,
    required String descriptionEn,
    required this.discount,
    required bool isRecommended,
    required bool isNewEntry,
    required bool isFlashSale,
    required bool isSale,
    required this.thumbnailPath,
    required this.imagePath,
    required this.activePromoCodesCount,
    required this.flashSale,
  })  : _priceNoVat = priceNoVat,
        _categories = List.unmodifiable(categories),
        _isFlashSale = isFlashSale,
        _isRecommended = isRecommended,
        _isNewEntry = isNewEntry,
        _isSale = isSale,
        _descriptionEn = descriptionEn,
        _descriptionSk = descriptionSk;

  ProductModel.fromJson(Map<String, dynamic> json)
      : assert(json[countryField] is CountryModel),
        assert(json[unitsTypeField] is UnitModel),
        assert(json[categoriesField] is List<CategoryModel>),
        assert(json[discountField] == null ||
            json[discountField] > 0 && json[discountField] <= 1),
        name = json[nameField],
        edition = json[editionField],
        year = json[yearField],
        age = json[ageField],
        country = json[countryField],
        cmat = json[cmatField],
        ean = json[eanField],
        _priceNoVat = json[priceNoVatField]?.toDouble(),
        count = json[countField],
        unitsCount = json[unitsCountField]?.toDouble(),
        unitsType = json[unitsTypeField],
        alcohol = json[alcoholField]?.toDouble(),
        _categories =
            List<CategoryModel>.unmodifiable(json[categoriesField] ?? []),
        _descriptionSk = json[descriptionSkField],
        _descriptionEn = json[descriptionEnField],
        discount = json[discountField]?.toDouble(),
        _isRecommended = json[isRecommendedField],
        _isNewEntry = json[isNewEntryField],
        _isFlashSale = json[isFlashSaleField],
        _isSale = json[isSaleField],
        thumbnailPath = json[thumbnailPathField],
        imagePath = json[imagePathField],
        activePromoCodesCount = json[activePromoCodesCountField],
        flashSale = json[flashSaleModelField] == null
            ? null
            : FlashSaleModel.fromMap(
                json[flashSaleModelField][FlashSaleModel.uniqueIdField],
                json[flashSaleModelField],
              );

  Map<String, dynamic> toFirebaseJson() {
    var result = <String, dynamic>{
      nameField: name,
      editionField: edition,
      yearField: year,
      ageField: age,
      cmatField: cmat,
      eanField: ean,
      priceNoVatField: _priceNoVat,
      countField: count,
      unitsCountField: unitsCount,
      alcoholField: alcohol,
      unitsTypeRefField: FirebaseFirestore.instance
          .collection(FirestoreCollections.unitsCollection)
          .doc(unitsType.id),
      categoryRefsField: _categories
          .expand<DocumentReference>(
            (category) => CategoryModel.allIds(category).map(
              (e) => FirebaseFirestore.instance
                  .collection(FirestoreCollections.categoriesCollection)
                  .doc(e),
            ),
          )
          .toList(),
      countryRefField: FirebaseFirestore.instance
          .collection(FirestoreCollections.countriesCollection)
          .doc(country.id),
      descriptionSkField: _descriptionSk,
      descriptionEnField: _descriptionEn,
      discountField: discount,
      isRecommendedField: _isRecommended,
      isNewEntryField: _isNewEntry,
      isFlashSaleField: _isFlashSale,
      isSaleField: _isSale,
      thumbnailPathField: thumbnailPath,
      imagePathField: imagePath,
      activePromoCodesCountField: activePromoCodesCount,
      isSpecialEditionField: isSpecialEdition,
      flashSaleModelField: flashSale?.toMap(),
    };

    // ignore: cascade_invocations
    result.updateAll((key, value) => value ?? FieldValue.delete());
    return result;
  }

  @override
  bool operator ==(other) =>
      other is ProductModel &&
      other.name == name &&
      other.edition == edition &&
      other.age == age &&
      other.year == year &&
      other.cmat == cmat &&
      other.ean == ean &&
      other._priceNoVat == _priceNoVat &&
      other.count == count &&
      other.unitsCount == unitsCount &&
      other.unitsType == unitsType &&
      other.alcohol == alcohol &&
      const ListEquality<dynamic>().equals(other._categories, _categories) &&
      other.country == country &&
      other._descriptionSk == _descriptionSk &&
      other._descriptionEn == _descriptionEn &&
      other.discount == discount &&
      other._isRecommended == _isRecommended &&
      other._isNewEntry == _isNewEntry &&
      other._isFlashSale == _isFlashSale &&
      other._isSale == _isSale &&
      other.thumbnailPath == thumbnailPath &&
      other.imagePath == imagePath &&
      other.activePromoCodesCount == activePromoCodesCount &&
      other.isSpecialEdition == isSpecialEdition &&
      other.flashSale == flashSale;

  @override
  int get hashCode =>
      name.hashCode ^
      edition.hashCode ^
      age.hashCode ^
      year.hashCode ^
      cmat.hashCode ^
      ean.hashCode ^
      _priceNoVat.hashCode ^
      count.hashCode ^
      unitsCount.hashCode ^
      unitsType.hashCode ^
      alcohol.hashCode ^
      const ListEquality<dynamic>().hash(_categories) ^
      country.hashCode ^
      _descriptionSk.hashCode ^
      _descriptionEn.hashCode ^
      discount.hashCode ^
      _isRecommended.hashCode ^
      _isNewEntry.hashCode ^
      _isFlashSale.hashCode ^
      _isSale.hashCode ^
      thumbnailPath.hashCode ^
      imagePath.hashCode ^
      activePromoCodesCount.hashCode ^
      isSpecialEdition.hashCode ^
      flashSale.hashCode;

  @override
  String toString() {
    return 'ProductModel{name: $name, edition: $edition, age: $age, year: $year, cmat: $cmat, ean: $ean, _priceNoVat: $_priceNoVat, count: $count, unitsCount: $unitsCount, unitsType: $unitsType, alcohol: $alcohol, _categories: $_categories, country: $country, descriptionSk: $_descriptionSk, descriptionEn: $_descriptionEn, discount: $discount, _isRecommended: $_isRecommended, _isNewEntry: $_isNewEntry, _isFlashSale: $_isFlashSale, thumbnailPath: $thumbnailPath, imagePath: $imagePath, activePromoCodesCount: $activePromoCodesCount, isSpecialEdition: $isSpecialEdition, flashSale: $flashSale}';
  }
}
