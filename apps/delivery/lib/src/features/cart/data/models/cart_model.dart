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

import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartModel extends Equatable {
  final int totalItems;
  final double totalProductsPrice;
  final double totalProductsVat;
  final String? shipping;
  final double shippingFeeTotal;
  final double shippingFeeVat;
  final String? promoCode;
  final double promoCodeValue;

  double get totalCartValue =>
      totalProductsPrice + shippingFeeTotal - promoCodeValue;
  double get totalCartVat => totalProductsVat + shippingFeeVat;
  // Promo code value is not counted here
  double get subTotal => totalCartValue + promoCodeValue - totalCartVat;

  const CartModel({
    required this.totalItems,
    required this.totalProductsPrice,
    required this.totalProductsVat,
    required this.shipping,
    required this.shippingFeeTotal,
    required this.shippingFeeVat,
    required this.promoCode,
    required this.promoCodeValue,
  });

  const CartModel.empty()
      : totalItems = 0,
        totalProductsPrice = 0,
        totalProductsVat = 0,
        shipping = null,
        shippingFeeTotal = 0,
        shippingFeeVat = 0,
        promoCode = null,
        promoCodeValue = 0;

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      totalItems: int.parse(map[CartFields.totalItemsField].toString()),
      totalProductsPrice:
          double.parse(map[CartFields.totalProductsPriceField].toString()),
      totalProductsVat:
          double.parse(map[CartFields.totalProductsVatField].toString()),
      shipping: map[CartFields.shippingField],
      shippingFeeTotal: double.parse(
          map[CartFields.shippingFeeTotalField]?.toString() ?? '0.00'),
      shippingFeeVat:
          double.parse(map[CartFields.shippingVatField]?.toString() ?? '0.00'),
      promoCode: map[CartFields.promoCodeField] as String?,
      promoCodeValue: double.parse(
          map[CartFields.promoCodeValueField]?.toString() ?? '0.00'),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      CartFields.totalItemsField: totalItems,
      CartFields.totalProductsPriceField: totalProductsPrice,
      CartFields.totalProductsVatField: totalProductsVat,
      CartFields.shippingField: shipping,
      CartFields.shippingFeeTotalField: shippingFeeTotal,
      CartFields.shippingVatField: shippingFeeVat,
      CartFields.promoCodeField: promoCode,
      CartFields.promoCodeValueField: promoCodeValue,
    };
  }

  @override
  List<Object?> get props => [
        totalItems,
        totalProductsPrice,
        totalProductsVat,
        shipping,
        shippingFeeTotal,
        shippingFeeVat,
        promoCode,
        promoCodeValue
      ];

  @override
  bool get stringify => true;
}

class CartFields {
  static const String totalItemsField = 'total_items';
  static const String totalProductsPriceField = 'products_total_price';
  static const String totalProductsVatField = 'products_vat';

  static const String shippingField = 'shipping';
  static const String shippingFeeTotalField = 'shipping_fee_total';
  static const String shippingVatField = 'shipping_vat';

  static const String promoCodeField = 'promo_code';
  static const String promoCodeValueField = 'promo_code_value';
}

class ChargeShipping {
  final String? shipping;

  const ChargeShipping._({
    required this.shipping,
  });

  factory ChargeShipping.fromMap(Map<String, dynamic> map) {
    return ChargeShipping._(
      shipping: map['shipping'] as String?,
    );
  }

  factory ChargeShipping.fromDeliveryOption(DeliveryOption? deliveryOption) {
    return ChargeShipping._(
      shipping: deliveryOption?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'shipping': shipping,
    } as Map<String, dynamic>;
  }
}
