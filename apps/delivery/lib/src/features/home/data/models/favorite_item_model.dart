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
class FavoriteItemModel extends Equatable {
  final DocumentReference? product;
  final DateTime? addedAt;

  const FavoriteItemModel({
    required this.product,
    required this.addedAt,
  });

  factory FavoriteItemModel.fromMap(Map<String, dynamic> map) {
    return FavoriteItemModel(
      product: map['product'] as DocumentReference?,
      addedAt: map['added_at']?.toDate(),
    );
  }

  factory FavoriteItemModel.fromProductModel(ProductModel productModel) {
    return FavoriteItemModel(
      product: '/warehouse/${productModel.uniqueId}' as DocumentReference,
      addedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'product': product,
      'added_at': addedAt,
    } as Map<String, dynamic>;
  }

  @override
  List<Object?> get props => [product, addedAt];

  @override
  bool get stringify => true;
}
