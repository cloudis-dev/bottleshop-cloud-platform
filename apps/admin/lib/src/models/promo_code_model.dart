import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PromoCodeType { value, percent }

String promoCodeType2String(PromoCodeType value) {
  switch (value) {
    case PromoCodeType.value:
      return 'value';
    case PromoCodeType.percent:
      return 'percent';
  }
}

PromoCodeType string2PromoCodeType(String value) {
  switch (value) {
    case 'value':
      return PromoCodeType.value;
    case 'percent':
      return PromoCodeType.percent;
  }

  throw UnimplementedError('No such PromoCodeType for string $value');
}

@immutable
class PromoCodeModel extends Equatable {
  final String code;
  final int remainingUsesCount;
  final double discountValue;
  final double minCartValue;
  final PromoCodeType promoCodeType;
  final DateTime? updated;

  String get uid => code;

  const PromoCodeModel({
    required this.code,
    required this.remainingUsesCount,
    required this.discountValue,
    required this.minCartValue,
    required this.promoCodeType,
    required this.updated,
  });

  const PromoCodeModel.empty()
      : code = '',
        remainingUsesCount = 0,
        discountValue = 0,
        minCartValue = 0,
        promoCodeType = PromoCodeType.value,
        updated = null;

  PromoCodeModel.fromJson(Map<String, dynamic> json)
      : code = json[PromoCodeFields.codeField],
        remainingUsesCount = json[PromoCodeFields.remainingUsesCountField],
        discountValue = json[PromoCodeFields.discountField].toDouble(),
        minCartValue = json[PromoCodeFields.minCartValueField].toDouble(),
        promoCodeType = json[PromoCodeFields.promoCodeTypeField] == null
            ? PromoCodeType.value
            : string2PromoCodeType(json[PromoCodeFields.promoCodeTypeField]),
        updated = (json[PromoCodeFields.updatedField] as Timestamp?)?.toDate();

  Map<String, dynamic> toFirebaseJson() => {
        PromoCodeFields.codeField: code,
        PromoCodeFields.remainingUsesCountField: remainingUsesCount,
        PromoCodeFields.discountField: discountValue,
        PromoCodeFields.minCartValueField: minCartValue,
        PromoCodeFields.promoCodeTypeField: promoCodeType2String(promoCodeType),
        PromoCodeFields.updatedField: FieldValue.serverTimestamp(),
      };

  PromoCodeModel copyWith({
    String? code,
    int? remainingUsesCount,
    double? discountValue,
    double? minCartValue,
    PromoCodeType? promoCodeType,
    DateTime? updated,
  }) =>
      PromoCodeModel(
        code: code ?? this.code,
        remainingUsesCount: remainingUsesCount ?? this.remainingUsesCount,
        discountValue: discountValue ?? this.discountValue,
        minCartValue: minCartValue ?? this.minCartValue,
        promoCodeType: promoCodeType ?? this.promoCodeType,
        updated: updated ?? this.updated,
      );

  @override
  List<Object?> get props => [
        uid,
        code,
        remainingUsesCount,
        discountValue,
        minCartValue,
        promoCodeType,
        updated,
      ];
}

class PromoCodeFields {
  static const String codeField = 'code';
  static const String remainingUsesCountField = 'remaining_uses_count';
  static const String discountField = 'discount_value';
  static const String minCartValueField = 'min_cart_value';
  static const String promoCodeTypeField = 'promo_code_type';
  static const String updatedField = 'updated';
}
