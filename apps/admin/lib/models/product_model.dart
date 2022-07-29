import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:bottleshop_admin/models/category_model.dart';
import 'package:bottleshop_admin/models/country_model.dart';
import 'package:bottleshop_admin/models/unit_model.dart';
import 'package:bottleshop_admin/utils/discount_util.dart';
import 'package:bottleshop_admin/utils/iterable_extension.dart';
import 'package:bottleshop_admin/utils/math_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class ProductModel extends Equatable {
  static const double vatMultiplier = 1.2;

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
  static const String unitsTypeField = 'unit';
  static const String alcoholField = 'alcohol';
  static const String countryField = 'country';
  static const String descriptionSkField = 'description_sk';
  static const String descriptionEnField = 'description_en';
  static const String discountField = 'discount';
  static const String categoriesField = 'categories';
  static const String isRecommendedField = 'is_recommended';
  static const String isNewEntryField = 'is_new_entry';
  static const String isSaleField = 'is_sale';
  static const String isFlashSaleField = 'is_flash_sale';
  static const String flashSaleModelField = 'flash_sale';
  static const String thumbnailPathField = 'thumbnail_path';
  static const String imagePathField = 'image_path';

  // Fields used only for sorting
  static const String nameSortField = '_name_sort';

  // fields after data join
  static const String countryRefField = 'country_ref';
  static const String unitsTypeRefField = 'unit_ref';
  static const String categoryRefsField = 'category_refs';

  final String name;
  final String? edition;
  final int? age;
  final int? year;
  final String cmat;
  final String ean;
  final double _priceNoVat;
  final int count;
  final double unitsCount;
  final UnitModel? unitsType;
  final double? alcohol;
  final UnmodifiableListView<CategoryModel> _categories;
  final CountryModel? country;
  final String? descriptionSk;
  final String? descriptionEn;
  final double? discount;
  final bool? _isRecommended;
  final bool? _isNewEntry;
  final bool? _isFlashSale;
  final bool? _isSale;
  final String? thumbnailPath;
  final String? imagePath;
  final FlashSaleModel? flashSale;

  CategoryModel? get mainCategory => _categories.tryGetById(0);
  List<CategoryModel?> get extraCategories => _categories.skip(1).toList();
  List<CategoryModel?> get allCategories => _categories;

  String get uniqueId => cmat;

  bool get hasImage => imagePath != null;
  bool get hasAlcohol => alcohol != null;
  bool get hasDiscount =>
      discount != null && !MathUtil.approximately(0, discount!);

  double get priceNoVat => _priceNoVat;
  double get priceWithVatWithoutDiscount => _priceNoVat * vatMultiplier;

  double get finalPriceNoVat =>
      priceNoVat *
      (discount == null ? 1 : DiscountUtil.getDiscountMultiplier(discount!));

  double get finalPriceWithVat =>
      priceWithVatWithoutDiscount *
      (discount == null ? 1 : DiscountUtil.getDiscountMultiplier(discount!));

  bool get isFlashSale => _isFlashSale ?? false;
  bool get isNewEntry => _isNewEntry ?? false;
  bool get isRecommended => _isRecommended ?? false;
  bool get isSale => _isSale ?? false;

  bool get isInAnySection =>
      isFlashSale || isNewEntry || isRecommended || isSale;

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
    required this.descriptionSk,
    required this.descriptionEn,
    required this.discount,
    required bool? isRecommended,
    required bool? isNewEntry,
    required bool? isFlashSale,
    required bool? isSale,
    required this.thumbnailPath,
    required this.imagePath,
    required this.flashSale,
  })  : _priceNoVat = priceNoVat,
        _categories = UnmodifiableListView(categories),
        _isFlashSale = isFlashSale,
        _isRecommended = isRecommended,
        _isNewEntry = isNewEntry,
        _isSale = isSale;

  ProductModel.empty()
      : name = '',
        edition = null,
        year = null,
        age = null,
        country = null,
        cmat = '',
        ean = '',
        _priceNoVat = 0,
        count = 0,
        unitsCount = 0,
        unitsType = null,
        alcohol = null,
        _categories = UnmodifiableListView<CategoryModel>([]),
        descriptionSk = null,
        descriptionEn = null,
        discount = null,
        _isRecommended = null,
        _isNewEntry = null,
        _isFlashSale = null,
        _isSale = null,
        thumbnailPath = null,
        imagePath = null,
        flashSale = null;

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
        _categories = UnmodifiableListView(json[categoriesField] ?? []),
        descriptionSk = json[descriptionSkField],
        descriptionEn = json[descriptionEnField],
        discount = json[discountField]?.toDouble(),
        _isRecommended = json[isRecommendedField],
        _isNewEntry = json[isNewEntryField],
        _isFlashSale = json[isFlashSaleField],
        _isSale = json[isSaleField],
        thumbnailPath = json[thumbnailPathField],
        imagePath = json[imagePathField],
        flashSale = json[flashSaleModelField] == null
            ? null
            : FlashSaleModel.fromJson(
                json[flashSaleModelField] as Map<String, dynamic>,
                json[flashSaleModelField][FlashSaleModel.uniqueIdField]
                    as String,
              );

  Map<String, dynamic> toFirebaseJson() {
    final result = <String, dynamic>{
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
          .collection(Constants.unitsCollection)
          .doc(unitsType!.id),
      categoryRefsField: _categories
          .expand<DocumentReference>(
            (category) => CategoryModel.allIds(category).map(
              (e) => FirebaseFirestore.instance
                  .collection(Constants.categoriesCollection)
                  .doc(e),
            ),
          )
          .toList(),
      countryRefField: FirebaseFirestore.instance
          .collection(Constants.countriesCollection)
          .doc(country!.id),
      descriptionSkField: descriptionSk,
      descriptionEnField: descriptionEn,
      discountField: discount,
      isRecommendedField: _isRecommended,
      isNewEntryField: _isNewEntry,
      isFlashSaleField: _isFlashSale,
      isSaleField: _isSale,
      thumbnailPathField: thumbnailPath,
      imagePathField: imagePath,
      flashSaleModelField: flashSale?.toFirebaseJson(),
    }..updateAll((key, dynamic value) => value ?? FieldValue.delete());

    return result;
  }

  ProductModel copyWith({
    String? name,
    Optional<String?>? edition,
    Optional<int?>? age,
    Optional<int?>? year,
    String? cmat,
    String? ean,
    double? priceNoVat,
    int? count,
    double? unitsCount,
    UnitModel? unitsType,
    Optional<double?>? alcohol,
    List<CategoryModel?>? categories,
    CountryModel? country,
    Optional<String?>? descriptionSk,
    Optional<String?>? descriptionEn,
    Optional<bool?>? isRecommended,
    Optional<bool?>? isNewEntry,
    Optional<bool?>? isFlashSale,
    Optional<bool?>? isSale,
    Optional<double?>? discount,
    Optional<String?>? thumbnailPath,
    Optional<String?>? imagePath,
    FlashSaleModel? flashSale,
  }) =>
      ProductModel(
        name: name ?? this.name,
        edition: edition == null ? this.edition : edition.orElse(null),
        age: age == null ? this.age : age.orElse(null),
        year: year == null ? this.year : year.orElse(null),
        cmat: cmat ?? this.cmat,
        ean: ean ?? this.ean,
        priceNoVat: priceNoVat ?? _priceNoVat,
        count: count ?? this.count,
        unitsCount: unitsCount ?? this.unitsCount,
        alcohol: alcohol == null ? this.alcohol : alcohol.orElse(null),
        categories:
            categories == null ? _categories : List.unmodifiable(categories),
        country: country ?? this.country,
        descriptionSk: descriptionSk == null
            ? this.descriptionSk
            : descriptionSk.orElse(null),
        descriptionEn: descriptionEn == null
            ? this.descriptionEn
            : descriptionEn.orElse(null),
        discount: discount == null
            ? this.discount
            : (MathUtil.approximately(discount.orElse(0)!, 0)
                ? null
                : discount.orElse(null)),
        unitsType: unitsType ?? this.unitsType,
        isRecommended:
            isRecommended == null ? _isRecommended : isRecommended.orElse(null),
        isNewEntry: isNewEntry == null ? _isNewEntry : isNewEntry.orElse(null),
        isFlashSale:
            isFlashSale == null ? _isFlashSale : isFlashSale.orElse(null),
        isSale: isSale == null ? _isSale : isSale.orElse(null),
        thumbnailPath: thumbnailPath == null
            ? this.thumbnailPath
            : thumbnailPath.orElse(null),
        imagePath: imagePath == null ? this.imagePath : imagePath.orElse(null),
        flashSale: flashSale ?? this.flashSale,
      );

  @override
  List<Object?> get props => [
        name,
        edition,
        age,
        year,
        cmat,
        ean,
        _priceNoVat,
        count,
        unitsCount,
        unitsType,
        alcohol,
        _categories,
        country,
        descriptionSk,
        descriptionEn,
        discount,
        _isRecommended,
        _isNewEntry,
        _isFlashSale,
        _isSale,
        flashSale,
        thumbnailPath,
        imagePath,
      ];
}
