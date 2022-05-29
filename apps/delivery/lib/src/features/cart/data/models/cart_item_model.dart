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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartItemModel extends Equatable {
  static const String countField = 'count';
  static const String productField = 'product';
  static const String paidPriceField = 'paid_price';

  final int count;
  final ProductModel product;
  final double paidPrice;

  const CartItemModel({
    required this.count,
    required this.product,
    required this.paidPrice,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      count: map[countField] as int,
      product: map[productField] as ProductModel,
      paidPrice: double.parse(map[paidPriceField].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      countField: count,
      productField: product.toFirebaseJson(),
      paidPriceField: paidPrice,
    };
  }

  @override
  List<Object?> get props => [
        count,
        product,
        paidPrice,
      ];

  @override
  bool get stringify => true;
}

/// This is used as the record in the user's cart.
@immutable
class CartRecord extends Equatable {
  final DocumentReference productRef;
  final int quantity;

  const CartRecord({
    required this.productRef,
    required this.quantity,
  });

  factory CartRecord.fromMap(Map<String, dynamic> map) {
    return CartRecord(
      productRef: map[CartRecordFields.productRefField] as DocumentReference,
      quantity: map[CartRecordFields.quantityField] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      CartRecordFields.productRefField: productRef,
      CartRecordFields.quantityField: quantity,
    } as Map<String, dynamic>;
  }

  CartRecord copyWith({
    DocumentReference? productRef,
    int? quantity,
  }) {
    if ((productRef == null || identical(productRef, this.productRef)) &&
        (quantity == null || identical(quantity, this.quantity))) {
      return this;
    }

    return CartRecord(
      productRef: productRef ?? this.productRef,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productRef, quantity];

  @override
  bool get stringify => true;
}

class CartRecordFields {
  static const String productRefField = 'product_ref';
  static const String quantityField = 'quantity';
}
