import 'package:bottleshop_admin/models/admin_user_model.dart';
import 'package:bottleshop_admin/models/order_type_model.dart';
import 'package:bottleshop_admin/models/product_model.dart';
import 'package:bottleshop_admin/models/promo_code_model.dart';
import 'package:bottleshop_admin/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class OrderModel extends Equatable {
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
  static const String promoCodeTypeField = 'promo_code_type';

  // fields after data join
  static const String customerField = 'customer';
  static const String orderTypeField = 'order_type';
  static const String preparingAdminField = 'preparing_admin';

  /// In the case of orders this is the document id.
  final String uniqueId;
  final int orderId;
  final UserModel customer;
  final OrderTypeModel orderType;
  final String? note;
  final List<CartItemModel> _cartItems;
  final double totalPaid;
  final int statusStepId;
  final List<DateTime> _statusStepsDates;
  final AdminUserModel? preparingAdmin;
  final String? promoCode;
  final double? promoCodeValue;
  final PromoCodeType? promoCodeType;

  double get promoCodeDiscountValue {
    switch (promoCodeType ?? PromoCodeType.value) {
      case PromoCodeType.value:
        return promoCodeValue!;
      case PromoCodeType.percent:
        return cartItemsValue * (promoCodeValue! / 100.0);
    }
  }

  double get cartItemsValue => _cartItems.fold<double>(
      0, (previousValue, element) => previousValue + element.paidPrice);

  List<CartItemModel> get cartItems => _cartItems;
  List<DateTime> get statusStepsDates => _statusStepsDates;

  bool get hasPromoCode => promoCode != null;

  bool get isTakenOverByAdmin => preparingAdmin != null;
  bool get isFirstOrderStatusStep => statusStepId == 0;

  bool get isComplete => statusStepId == orderType.orderStepsIds.last;

  bool get isFollowingStatusIdComplete =>
      isComplete || getFollowingStatusId == orderType.orderStepsIds.last;

  int? get getFollowingStatusId {
    if (isComplete) {
      return null;
    } else {
      return orderType
          .orderStepsIds[orderType.orderStepsIds.indexOf(statusStepId) + 1];
    }
  }

  bool get hasNote => (note ?? '').isNotEmpty;

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
    required this.preparingAdmin,
    required this.promoCode,
    required this.promoCodeValue,
    required this.promoCodeType,
  })  : _cartItems = List.unmodifiable(cartItems),
        _statusStepsDates = List.unmodifiable(statusStepsDates);

  OrderModel.fromJson(Map<String, dynamic> json, String documentId)
      : assert(json[orderTypeField] is OrderTypeModel),
        assert((json[orderTypeField] as OrderTypeModel)
            .orderStepsIds
            .contains(json[statusStepIdField])),
        assert(json[statusTimestampsField].length > 0),
        assert(((json[orderTypeField] as OrderTypeModel)
                    .orderStepsIds
                    .indexOf(json[statusStepIdField]) +
                1) ==
            json[statusTimestampsField].length),
        assert(
            json[preparingAdminField] != null || json[statusStepIdField] == 0),
        uniqueId = documentId,
        orderId = json[idField],
        customer = UserModel.fromMap(
          json[customerField][UserFields.uid],
          json[customerField],
        ),
        orderType = json[orderTypeField],
        note = json[noteField],
        _cartItems = List<CartItemModel>.unmodifiable(
            json[cartItemsField].map((e) => CartItemModel.fromJson(e))),
        totalPaid = json[totalPaidField]?.toDouble(),
        statusStepId = json[statusStepIdField],
        _statusStepsDates = List<DateTime>.unmodifiable(
            json[statusTimestampsField].map(
                (e) => DateTime.fromMillisecondsSinceEpoch(e.seconds * 1000))),
        preparingAdmin = json[preparingAdminField],
        promoCode = json[promoCodeField],
        promoCodeValue = json[promoCodeValueField]?.toDouble(),
        promoCodeType = json[promoCodeTypeField] == null
            ? null
            : string2PromoCodeType(json[promoCodeTypeField] as String);

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
        preparingAdmin,
        promoCode,
        promoCodeValue,
        promoCodeType,
      ];
}

@immutable
class CartItemModel extends Equatable {
  static const String countField = 'count';
  static const String productField = 'product';
  static const String promoCodeField = 'promo_code';
  static const String paidPriceField = 'paid_price';

  final int count;
  final ProductModel product;
  final double paidPrice;

  const CartItemModel({
    required this.count,
    required this.product,
    required this.paidPrice,
  });

  CartItemModel.fromJson(Map<String, dynamic> json)
      : assert(json[productField] is ProductModel),
        count = json[countField] as int,
        product = json[productField] as ProductModel,
        paidPrice = (json[paidPriceField] as num).toDouble();

  @override
  List<Object?> get props => [count, product, paidPrice];
}
