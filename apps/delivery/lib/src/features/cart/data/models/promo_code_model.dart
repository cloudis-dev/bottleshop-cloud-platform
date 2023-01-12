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

import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:equatable/equatable.dart';

class PromoCodeModel extends Equatable {
  static const String codeField = 'code';
  static const String remainingUsesCountField = 'remaining_uses_count';
  static const String discountField = 'discount_value';
  static const String minCartValueField = 'min_cart_value';

  final String uid;
  final String code;
  final int remainingUsesCount;
  final double discount;
  final double minCartValue;

  const PromoCodeModel({
    required this.uid,
    required this.code,
    required this.remainingUsesCount,
    required this.discount,
    required this.minCartValue,
  });

  bool isPromoValid(CartModel cart, OrderTypeModel? orderType) {
    return remainingUsesCount > 0 &&
        minCartValue <= (orderType?.feeWithVat ?? 0) + cart.totalProductsPrice;
  }

  PromoCodeModel.fromJson(Map<String, dynamic> json, this.uid)
      : code = json[codeField],
        remainingUsesCount = json[remainingUsesCountField],
        discount = json[discountField],
        minCartValue = json[minCartValueField];

  Map<String, dynamic> toFirebaseJson() {
    return {
      codeField: code,
      remainingUsesCountField: remainingUsesCount,
      discountField: discount,
      minCartValueField: minCartValue
    };
  }

  @override
  List<Object?> get props => [
        uid,
        code,
        remainingUsesCount,
        discount,
        minCartValue,
      ];

  @override
  bool get stringify => true;
}
