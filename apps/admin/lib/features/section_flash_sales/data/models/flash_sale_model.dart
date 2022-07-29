import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// This model does not contain the products.
/// The products need to be queried separately.
@immutable
class FlashSaleModel {
  static const String uniqueIdField = 'uid';
  static const String flashSaleUntilField = 'flash_sale_until';
  static const String nameField = 'name';

  final String uniqueId;
  final String name;
  final DateTime flashSaleUntil;

  DateTime get flashSaleUntilDate => DateTime(
        flashSaleUntil.year,
        flashSaleUntil.month,
        flashSaleUntil.day,
      );

  TimeOfDay get flashSaleUntilTime => TimeOfDay(
        hour: flashSaleUntil.hour,
        minute: flashSaleUntil.minute,
      );

  const FlashSaleModel({
    required this.uniqueId,
    required this.name,
    required this.flashSaleUntil,
  });

  FlashSaleModel.empty()
      : uniqueId = '',
        name = '',
        flashSaleUntil = DateTime.fromMicrosecondsSinceEpoch(0);

  FlashSaleModel.fromJson(Map<String, dynamic> json, this.uniqueId)
      : name = json[nameField],
        flashSaleUntil = DateTime.fromMillisecondsSinceEpoch(
          (json[flashSaleUntilField] is Timestamp
                  ? json[flashSaleUntilField].seconds
                  : json[flashSaleUntilField]['_seconds']) *
              1000,
        );

  Map<String, dynamic> toFirebaseJson() {
    final result = <String, dynamic>{
      flashSaleUntilField: Timestamp.fromDate(flashSaleUntil),
      nameField: name,
      uniqueIdField: uniqueId,
    }..updateAll((key, value) => value ?? FieldValue.delete());
    return result;
  }

  @override
  bool operator ==(other) =>
      other is FlashSaleModel &&
      other.uniqueId == uniqueId &&
      other.name == name &&
      other.flashSaleUntil == flashSaleUntil;

  @override
  int get hashCode =>
      uniqueId.hashCode ^ name.hashCode ^ flashSaleUntil.hashCode;

  FlashSaleModel copyWith({
    String? name,
    DateTime? flashSaleUntil,
  }) =>
      FlashSaleModel(
        uniqueId: uniqueId,
        name: name ?? this.name,
        flashSaleUntil: flashSaleUntil ?? this.flashSaleUntil,
      );
}
