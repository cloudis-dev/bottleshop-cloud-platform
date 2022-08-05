import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:bottleshop_admin/src/models/localized_model.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum OrderTypeCode {
  pickUp,
  homeDelivery,
  quickDeliveryBa,
  closeAreasDeliveryBa,
  cashOnDelivery,
}

@immutable
class OrderTypeModel {
  static const String nameField = 'name';
  static const String localizedNameField = 'localized_name';
  static const String orderStepsIdsField = 'order_steps_ids';
  static const String codeField = 'code';
  static const String shippingFeeNoVatField = 'shipping_fee_eur_no_vat';

  final String id;
  final String name;
  final LocalizedModel localizedName;
  final List<int> _orderStepsIds;
  final String _code;
  final double shippingFeeNoVat;

  double get shippingFeeWithVat =>
      shippingFeeNoVat * ProductModel.vatMultiplier;

  bool get hasShippingFee => !MathUtil.approximately(shippingFeeNoVat, 0);

  List<int> get orderStepsIds => _orderStepsIds;

  OrderTypeCode get orderTypeCode {
    switch (_code) {
      case 'pick-up':
        return OrderTypeCode.pickUp;
      case 'home-delivery':
        return OrderTypeCode.homeDelivery;
      case 'quick-delivery-BA':
        return OrderTypeCode.quickDeliveryBa;
      case 'close-areas-delivery-ba':
        return OrderTypeCode.closeAreasDeliveryBa;
      case 'cash-on-delivery':
        return OrderTypeCode.cashOnDelivery;
    }
    throw Exception('Order type unknown');
  }

  OrderTypeModel({
    required this.id,
    required this.name,
    required this.localizedName,
    required List<int> orderStepsIds,
    required String code,
    required this.shippingFeeNoVat,
  })  : _orderStepsIds = List.unmodifiable(orderStepsIds),
        _code = code;

  OrderTypeModel.fromJson(Map<String, dynamic> json, this.id)
      : name = json[nameField],
        localizedName = LocalizedModel.fromJson(json[localizedNameField]),
        _orderStepsIds =
            List.unmodifiable(json[orderStepsIdsField].cast<int>()),
        _code = json[codeField],
        shippingFeeNoVat = json[shippingFeeNoVatField]?.toDouble();

  @override
  bool operator ==(other) =>
      other is OrderTypeModel &&
      other.id == id &&
      other.name == name &&
      other.localizedName == localizedName &&
      ListEquality().equals(other.orderStepsIds, orderStepsIds) &&
      other._code == _code &&
      other.shippingFeeNoVat == shippingFeeNoVat;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      localizedName.hashCode ^
      orderStepsIds.fold(
          0, (previousValue, element) => previousValue ^ element.hashCode) ^
      _code.hashCode ^
      shippingFeeNoVat.hashCode;
}
