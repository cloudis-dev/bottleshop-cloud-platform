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

import 'package:delivery/src/core/data/models/localized_model.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/utils/math_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DeliveryOption {
  homeDelivery,
  pickUp,
  quickDeliveryBa,
  closeAreasDeliveryBa,
  cashOnDelivery;

  static const kOrderTypePickUp = 'pick-up';
  static const kOrderTypeHomeDelivery = 'home-delivery';
  static const kOrderTypeQuickBa = 'quick-delivery-BA';
  static const kOrderTypeCloseAreaBa = 'close-areas-delivery-ba';
  static const kOrderTypeCashOnDelivery = 'cash-on-delivery';

  @override
  String toString() {
    switch (this) {
      case DeliveryOption.homeDelivery:
        return kOrderTypeHomeDelivery;
      case DeliveryOption.pickUp:
        return kOrderTypePickUp;
      case DeliveryOption.quickDeliveryBa:
        return kOrderTypeQuickBa;
      case DeliveryOption.closeAreasDeliveryBa:
        return kOrderTypeCloseAreaBa;
      case DeliveryOption.cashOnDelivery:
        return kOrderTypeCashOnDelivery;
    }
  }
}

@immutable
class OrderTypeModel extends Equatable {
  static const String codeField = 'code';
  static const String nameField = 'name';
  static const String localizedNameField = 'localized_name';
  static const String orderStepsIdsField = 'order_steps_ids';
  static const String shippingFeeField = 'shipping_fee_eur_no_vat';
  static const String descriptionField = 'description';
  static const String localizedDescriptionField = 'localized_description';

  final String _code;
  final String id;
  final String _name;
  final LocalizedModel _localizedName;
  final String _description;
  final LocalizedModel _localizedDescription;
  final List<int> _orderStepsIds;
  final double shippingFeeNoVat;

  DeliveryOption? get deliveryOption {
    switch (_code) {
      case DeliveryOption.kOrderTypePickUp:
        return DeliveryOption.pickUp;
      case DeliveryOption.kOrderTypeHomeDelivery:
        return DeliveryOption.homeDelivery;
      case DeliveryOption.kOrderTypeQuickBa:
        return DeliveryOption.quickDeliveryBa;
      case DeliveryOption.kOrderTypeCloseAreaBa:
        return DeliveryOption.closeAreasDeliveryBa;
      case DeliveryOption.kOrderTypeCashOnDelivery:
        return DeliveryOption.cashOnDelivery;
    }
    return null;
  }

  double get feeWithVat => shippingFeeNoVat * 1.2;
  double get feeVat => feeWithVat - shippingFeeNoVat;

  List<int?> get orderStepsIds => _orderStepsIds;

  bool get isPaymentRequired => !MathUtils.approximately(0, shippingFeeNoVat);

  String? getName(LanguageMode lang) {
    switch (lang) {
      case LanguageMode.en:
        return _name;
      case LanguageMode.sk:
        return _localizedName.slovak;
    }
  }

  String? getDescription(LanguageMode lang) {
    switch (lang) {
      case LanguageMode.en:
        return _description;
      case LanguageMode.sk:
        return _localizedDescription.slovak;
    }
  }

  OrderTypeModel({
    required this.id,
    required String code,
    required String name,
    required LocalizedModel localizedName,
    required List<int> orderStepsIds,
    required this.shippingFeeNoVat,
    required String description,
    required LocalizedModel localizedDescription,
  })  : _orderStepsIds = List.unmodifiable(orderStepsIds),
        _code = code,
        _name = name,
        _localizedName = localizedName,
        _description = description,
        _localizedDescription = localizedDescription;

  OrderTypeModel.fromMap(this.id, Map<String, dynamic> data)
      : _code = data[codeField],
        _name = data[nameField],
        _localizedName = LocalizedModel.fromMap(data[localizedNameField]),
        _orderStepsIds =
            List.unmodifiable(data[orderStepsIdsField].cast<int>()),
        shippingFeeNoVat = data[shippingFeeField].toDouble(),
        _description = data[descriptionField],
        _localizedDescription =
            LocalizedModel.fromMap(data[localizedDescriptionField]);

  @override
  List<Object?> get props => [
        id,
        _code,
        _name,
        _localizedName,
        _orderStepsIds,
        shippingFeeNoVat,
        _description,
        _localizedDescription,
      ];

  @override
  bool get stringify => true;
}
