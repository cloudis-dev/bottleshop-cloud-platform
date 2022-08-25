// import 'package:bottleshop_admin/models/category_model.dart';
// import 'package:bottleshop_admin/models/country_model.dart';
// import 'package:bottleshop_admin/models/product_model.dart';
// import 'package:bottleshop_admin/models/unit_model.dart';
// import 'package:bottleshop_admin/utils/logical_utils.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:optional/optional.dart';
//
// import 'product_image_view_model.dart';
//
// enum ViewModelState { initialized, loading, error }
//
// class ProductEditViewModel extends ChangeNotifier {
//   ProductImageViewModel? _imageModel;
//   ProductImageViewModel? get imageModel => _imageModel;
//
//   ProductModel? _editedProductDetails;
//   late final List<bool> _areCategoriesComplete;
//
//   final bool isCreatingNewProduct;
//
//   /// _editedProductDetails is null at the beginning
//   ProductModel get currentProductDetails =>
//       _editedProductDetails ?? initialProductDetails;
//
//   late final ProductModel initialProductDetails;
//
//   ViewModelState get currentState => _currentState;
//   ViewModelState _currentState;
//
//   ProductEditViewModel(
//     Future<ProductModel> initialProductFuture,
//     this.isCreatingNewProduct,
//   ) : _currentState = ViewModelState.loading {
//     initialProductFuture.then(
//       (value) {
//         initialProductDetails = value;
//         _areCategoriesComplete = List.generate(
//             initialProductDetails.allCategories.length, (_) => true);
//         _imageModel = ProductImageViewModel(
//             notifyListeners, initialProductDetails.imagePath);
//         _currentState = ViewModelState.initialized;
//         notifyListeners();
//       },
//     ).catchError(
//       (_) {
//         _currentState = ViewModelState.error;
//         notifyListeners();
//       },
//     );
//   }
//
//   @override
//   Future dispose() async {
//     await _imageModel?.dispose();
//     super.dispose();
//   }
//
//   bool isCurrentProductValid() =>
//       _imageModel!.isModelValid &&
//       (isCategoryChanged() ? _areCategoriesComplete.every((e) => e) : true) &&
//       currentProductDetails.name != null &&
//       LogicalUtils.implication(
//         currentProductDetails.age != null || currentProductDetails.year != null,
//         LogicalUtils.xor(
//           currentProductDetails.age != null,
//           currentProductDetails.year != null,
//         ),
//       ) &&
//       currentProductDetails.cmat != null &&
//       currentProductDetails.ean != null &&
//       currentProductDetails.priceNoVat != null &&
//       currentProductDetails.count != null &&
//       currentProductDetails.unitsCount != null &&
//       currentProductDetails.unitsType != null &&
//       currentProductDetails.country != null;
//
//   bool isModelChanged() =>
//       _imageModel!.isModelChanged ||
//       (_editedProductDetails != null &&
//           _editedProductDetails != initialProductDetails);
//
//   bool isNameChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.name != initialProductDetails.name;
//   bool isEditionChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.edition != initialProductDetails.edition;
//   bool isAgeChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.age != initialProductDetails.age;
//   bool isYearChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.year != initialProductDetails.year;
//   bool isCmatChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.cmat != initialProductDetails.cmat;
//   bool isEanChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.ean != initialProductDetails.ean;
//   bool isPriceChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.priceNoVat != initialProductDetails.priceNoVat;
//   bool isCountChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.count != initialProductDetails.count;
//   bool isUnitsCountChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.unitsCount != initialProductDetails.unitsCount;
//   bool isUnitsTypeChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.unitsType != initialProductDetails.unitsType;
//   bool isAlcoholChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.alcohol != initialProductDetails.alcohol;
//   bool isCategoryChanged() =>
//       _editedProductDetails != null &&
//       !ListEquality().equals(
//         _editedProductDetails!.allCategories,
//         initialProductDetails.allCategories,
//       );
//   bool isCountryChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.country != initialProductDetails.country;
//   bool isDescriptionSkChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.descriptionSk !=
//           initialProductDetails.descriptionSk;
//   bool isDescriptionEnChanged() =>
//       _editedProductDetails != null &&
//       _editedProductDetails!.descriptionEn !=
//           initialProductDetails.descriptionEn;
//
//   void onNameChanged(String value) {
//     var res = value.trim();
//     if (res.isNotEmpty) {
//       res = res[0].toUpperCase() + res.substring(1);
//     }
//     _modify(
//       currentProductDetails.copyWith(
//         name: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void onEditionChanged(String value) {
//     var res = value.trim();
//     if (res.isNotEmpty) {
//       res = res[0].toUpperCase() + res.substring(1);
//     }
//     _modify(
//       currentProductDetails.copyWith(
//         edition: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void onAgeChanged(String value) {
//     final res = int.tryParse(value);
//     // if (res == null) ageTextFieldCtrl.clear();
//     _modify(currentProductDetails.copyWith(
//         age: Optional.of(res), year: Optional.empty()));
//   }
//
//   void onYearChanged(String value) {
//     final res = int.tryParse(value);
//     // if (res == null) yearTextFieldCtrl.clear();
//     _modify(currentProductDetails.copyWith(
//         year: Optional.of(res), age: Optional.empty()));
//   }
//
//   void onCmatChanged(String value) {
//     final res = value.trim();
//     _modify(
//       currentProductDetails.copyWith(
//         cmat: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void onEanChanged(String value) {
//     final res = value.trim();
//     _modify(
//       currentProductDetails.copyWith(
//         ean: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void onPriceWithVatChanged(String value) {
//     value = value.replaceAll(',', '.');
//     var res = double.tryParse(value);
//     if (res == null) {
//       // priceTextFieldCtrl.clear();
//     } else {
//       res = res / ProductModel.vatMultiplier;
//       res = double.tryParse(res.toStringAsFixed(2));
//     }
//     _modify(currentProductDetails.copyWith(priceNoVat: Optional.of(res)));
//   }
//
//   void onCountChanged(String value) {
//     final res = int.tryParse(value);
//     // if (res == null) countTextFieldCtrl.clear();
//     _modify(currentProductDetails.copyWith(count: Optional.of(res)));
//   }
//
//   void onUnitsCountChanged(String value) {
//     value = value.replaceAll(',', '.');
//     final res =
//         double.tryParse(double.tryParse(value)?.toStringAsFixed(2) ?? '');
//     // if (res == null) unitsCountTextFieldCtrl.clear();
//     _modify(currentProductDetails.copyWith(unitsCount: Optional.of(res)));
//   }
//
//   void onUnitsTypeChanged(UnitModel? value) =>
//       _modify(currentProductDetails.copyWith(unitsType: value));
//
//   void setOnAlcoholEnabled(bool enabled) {
//     _modify(currentProductDetails.copyWith(
//         alcohol: enabled ? Optional.of(0) : Optional.empty()));
//   }
//
//   void onAlcoholChanged(String value) {
//     value = value.replaceAll(',', '.');
//     var res = double.tryParse(double.tryParse(value)?.toStringAsFixed(1) ?? '');
//     // if (res == null) alcoholTextFieldCtrl.clear();
//     _modify(currentProductDetails.copyWith(alcohol: Optional.of(res ?? 0)));
//   }
//
//   void addExtraCategory() {
//     final List<CategoryModel?> newCategories =
//         currentProductDetails.allCategories.toList();
//     if (newCategories.isEmpty) {
//       newCategories.add(null);
//       _areCategoriesComplete.add(false);
//     }
//     newCategories.add(null);
//     _areCategoriesComplete.add(false);
//
//     assert(_areCategoriesComplete.length == newCategories.length);
//     _modify(currentProductDetails.copyWith(categories: newCategories));
//   }
//
//   void removeExtraCategory(int id) {
//     assert(id > 0);
//     final newCategories = currentProductDetails.allCategories.toList();
//     newCategories.removeAt(id);
//     _areCategoriesComplete.removeAt(id);
//
//     assert(_areCategoriesComplete.length == newCategories.length);
//     _modify(currentProductDetails.copyWith(categories: newCategories));
//   }
//
//   void onCategoryChanged(
//     CategoryModel? value,
//     int id,
//     bool isCategoryComplete,
//   ) {
//     final List<CategoryModel?> newCategories =
//         currentProductDetails.allCategories.toList();
//     assert(id <= newCategories.length);
//     assert(newCategories.length == _areCategoriesComplete.length);
//
//     if (id == newCategories.length) {
//       newCategories.add(value);
//       _areCategoriesComplete.add(isCategoryComplete);
//     } else {
//       newCategories[id] = value;
//       _areCategoriesComplete[id] = isCategoryComplete;
//     }
//
//     assert(_areCategoriesComplete.length == newCategories.length);
//     _modify(currentProductDetails.copyWith(categories: newCategories));
//   }
//
//   void onCountryChanged(CountryModel? value) =>
//       _modify(currentProductDetails.copyWith(country: value));
//
//   void onDescriptionSkChanged(String value) {
//     final res = value.trim();
//     _modify(
//       currentProductDetails.copyWith(
//         descriptionSk: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void onDescriptionEnChanged(String value) {
//     final res = value.trim();
//     _modify(
//       currentProductDetails.copyWith(
//         descriptionEn: res.isEmpty ? Optional.empty() : Optional.of(res),
//       ),
//     );
//   }
//
//   void _modify(ProductModel productDetails) {
//     _editedProductDetails = productDetails;
//     notifyListeners();
//   }
// }
