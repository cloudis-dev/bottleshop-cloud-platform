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

import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrderModel extends Equatable {
  final String uniqueId;
  final int orderId;
  final UserModel customer;
  final OrderTypeModel orderType;
  final String? note;
  final List<CartItemModel> _cartItems;
  final double totalPaid;
  final int statusStepId;
  final DateTime createdAt;
  final List<DateTime> _statusStepsDates;
  final String? promoCode;
  final double? promoCodeValue;

  List<CartItemModel> get cartItems => _cartItems;

  List<DateTime> get statusStepsDates => _statusStepsDates;

  bool get hasPromoCode => promoCode != null;

  bool get isFirstOrderStatusStep => statusStepId == 0;

  bool get isComplete => statusStepId == orderType.orderStepsIds.last;

  bool get isFollowingStatusIdComplete => isComplete || getFollowingStatusId == orderType.orderStepsIds.last;

  int? get getFollowingStatusId {
    assert(!isComplete);
    return orderType.orderStepsIds[orderType.orderStepsIds.indexOf(statusStepId) + 1];
  }

  OrderModel({
    required this.uniqueId,
    required this.orderId,
    required this.customer,
    required this.orderType,
    required this.note,
    required List<CartItemModel> cartItems,
    required this.totalPaid,
    required this.statusStepId,
    required List<DateTime> statusStepsDates,
    required this.createdAt,
    required this.promoCode,
    required this.promoCodeValue,
  })  : _cartItems = List.unmodifiable(cartItems),
        _statusStepsDates = List.unmodifiable(statusStepsDates);

  OrderModel.fromJson(Map<String, dynamic> json, this.uniqueId)
      : assert(json[OrderModelFields.orderTypeField] is OrderTypeModel),
        assert((json[OrderModelFields.orderTypeField] as OrderTypeModel)
            .orderStepsIds
            .contains(json[OrderModelFields.statusStepIdField])),
        assert(json[OrderModelFields.statusTimestampsField].length > 0),
        assert((json[OrderModelFields.orderTypeField] as OrderTypeModel)
                    .orderStepsIds
                    .indexOf(json[OrderModelFields.statusStepIdField]) +
                1 ==
            json[OrderModelFields.statusTimestampsField].length),
        orderId = json[OrderModelFields.idField],
        customer =
            UserModel.fromMap(json[OrderModelFields.userField][UserFields.uid], json[OrderModelFields.userField]),
        orderType = json[OrderModelFields.orderTypeField],
        note = json[OrderModelFields.noteField],
        _cartItems = List<CartItemModel>.unmodifiable(
            json[OrderModelFields.cartItemsField].map((dynamic e) => CartItemModel.fromMap(e))),
        totalPaid = double.parse(json[OrderModelFields.totalPaidField].toString()),
        statusStepId = json[OrderModelFields.statusStepIdField],
        _statusStepsDates = List<DateTime>.unmodifiable(json[OrderModelFields.statusTimestampsField]
            .map((dynamic e) => DateTime.fromMillisecondsSinceEpoch(e.seconds * 1000))),
        createdAt = DateTime.fromMillisecondsSinceEpoch(json[OrderModelFields.createdAtTimestampField].seconds * 1000),
        promoCode = json[OrderModelFields.promoCodeField],
        promoCodeValue = json[OrderModelFields.promoCodeValueField]?.toDouble();

  @override
  List<Object?> get props => [
        uniqueId,
        orderId,
        customer,
        orderType,
        note,
        cartItems,
        totalPaid,
        statusStepId,
        statusStepsDates,
        createdAt,
        promoCode,
        promoCodeValue
      ];
}

class OrderModelFields {
  // firebase json fields
  static const String idField = 'id';
  static const String noteField = 'note';
  static const String cartItemsField = 'cart';
  static const String totalPaidField = 'total_paid';
  static const String orderTypeRefField = 'order_type_ref';
  static const String statusStepIdField = 'status_step_id';
  static const String statusTimestampsField = 'status_timestamps';
  static const String createdAtTimestampField = 'created_at';
  static const String preparingAdminRefField = 'preparing_admin_ref';
  static const String promoCodeField = 'promo_code';
  static const String promoCodeValueField = 'promo_code_value';

  // fields after data join
  static const String userField = 'customer';
  static const String orderTypeField = 'order_type';
}
