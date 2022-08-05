import 'package:bottleshop_admin/src/core/utils/discount_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class DiscountSetupViewModel extends ChangeNotifier {
  ProductModel? _editedProduct;
  ProductModel initialProduct;

  ProductModel get currentProduct => _editedProduct ?? initialProduct;

  DiscountSetupViewModel({required ProductModel product})
      : initialProduct = product;

  bool get isModelChanged =>
      _editedProduct != null && initialProduct != _editedProduct;

  bool get isDiscountModified =>
      _editedProduct != null &&
      initialProduct.discount != _editedProduct!.discount;

  void onChangeDiscount(String value) {
    final res = int.tryParse(value);
    // if (res == null) {
    //   discountTextFieldCtrl.clear();
    // }
    _modify(
      currentProduct.copyWith(
        discount: Optional.of(
            res == null ? null : DiscountUtil.getDiscountFromPercentage(res)),
      ),
    );
  }

  void _modify(ProductModel product) {
    _editedProduct = product;
    notifyListeners();
  }
}
