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

import 'package:collection/collection.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartModel extends Equatable {
  final UnmodifiableListView<CartItemModel> _cartItems;

  UnmodifiableListView<CartItemModel> get products => _cartItems;
  double get totalProductsPrice =>
      _cartItems.map((e) => e.product.finalPrice * e.count).sum;
  double get totalProductsPriceNoVat =>
      _cartItems.map((e) => e.product.priceNoVat * e.count).sum;
  double get totalProductsVat =>
      _cartItems.map((e) => e.product.productVat * e.count).sum;

  CartModel({
    required List<CartItemModel> cartItems,
  }) : _cartItems = UnmodifiableListView(cartItems);

  CartModel.empty() : _cartItems = UnmodifiableListView([]);

  @override
  List<Object?> get props => [_cartItems];

  @override
  bool get stringify => true;
}
