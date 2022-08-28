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
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/utils/language_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DeliveryOption {
  homeDelivery,
  pickUp,
  quickDeliveryBa,
  closeAreasDeliveryBa,
  none,
  cashOnDelivery,
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

  DeliveryOption get deliveryOption {
    switch (_code) {
      case kOrderTypePickUp:
        return DeliveryOption.pickUp;
      case kOrderTypeHomeDelivery:
        return DeliveryOption.homeDelivery;
      case kOrderTypeQuickBa:
        return DeliveryOption.quickDeliveryBa;
      case kOrderTypeCloseAreaBa:
        return DeliveryOption.closeAreasDeliveryBa;
      case kOrderTypeCashOnDelivery:
        return DeliveryOption.cashOnDelivery;
    }
    return DeliveryOption.none;
  }

  static String codeFromDeliveryOption(DeliveryOption? deliveryOption) {
    switch (deliveryOption) {
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
      case DeliveryOption.none:
      default:
        break;
    }

    throw Exception('No such delivery option available');
  }

  double get shippingFeeWithVat => shippingFeeNoVat * 1.2;

  List<int?> get orderStepsIds => _orderStepsIds;

  String? getName(Locale locale) {
    switch (LanguageUtils.parseLocale(locale)) {
      case LocaleLanguage.slovak:
        return _localizedName.slovak;
      case LocaleLanguage.english:
        return _name;
    }
  }

  String? getDescription(Locale locale) {
    switch (LanguageUtils.parseLocale(locale)) {
      case LocaleLanguage.slovak:
        return _localizedDescription.slovak;
      case LocaleLanguage.english:
        return _description;
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
