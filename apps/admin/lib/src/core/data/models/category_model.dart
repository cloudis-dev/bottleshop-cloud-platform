import 'package:bottleshop_admin/src/core/data/models/category_plain_model.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryModel {
  final CategoryPlainModel categoryDetails;
  final CategoryModel? subCategory;

  const CategoryModel({
    required this.categoryDetails,
    required this.subCategory,
  });

  @override
  bool operator ==(other) =>
      other is CategoryModel &&
      other.categoryDetails == categoryDetails &&
      other.subCategory == subCategory;

  @override
  int get hashCode => categoryDetails.hashCode ^ subCategory.hashCode;

  static Iterable<CategoryPlainModel> allCategoryDetails(
      CategoryModel? model) sync* {
    if (model == null) return;
    yield model.categoryDetails;
    yield* allCategoryDetails(model.subCategory);
  }

  static Iterable<String> allLocalizedNames(CategoryModel? model) sync* {
    if (model == null) return;
    yield model.categoryDetails.localizedName.local;
    yield* allLocalizedNames(model.subCategory);
  }

  static Iterable<String> allIds(CategoryModel? model) sync* {
    if (model == null) return;
    yield model.categoryDetails.id;
    yield* allIds(model.subCategory);
  }

  static CategoryModel appendCategory(
      CategoryModel? model, CategoryPlainModel details) {
    if (model == null) {
      return CategoryModel(categoryDetails: details, subCategory: null);
    }
    return CategoryModel(
      categoryDetails: model.categoryDetails,
      subCategory: appendCategory(model.subCategory, details),
    );
  }

  static CategoryModel? changeCategory(
      CategoryModel? model, int id, CategoryPlainModel details) {
    if (model == null) return null;
    if (id == 0) {
      return CategoryModel(categoryDetails: details, subCategory: null);
    }
    return CategoryModel(
        categoryDetails: model.categoryDetails,
        subCategory: changeCategory(model.subCategory, id - 1, details));
  }
}
