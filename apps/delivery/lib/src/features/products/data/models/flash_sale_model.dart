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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// This model does not contain the products.
/// The products need to be queried separately.
@immutable
class FlashSaleModel extends Equatable {
  static const String uniqueIdField = 'uid';
  static const String flashSaleUntilField = 'flash_sale_until';
  static const String nameField = 'name';

  final String? uniqueId;
  final String? name;
  final DateTime flashSaleUntil;

  FlashSaleModel({
    required this.uniqueId,
    required this.name,
    required this.flashSaleUntil,
  });

  FlashSaleModel.fromMap(this.uniqueId, Map<String, dynamic> json)
      : name = json[nameField],
        flashSaleUntil = DateTime.fromMillisecondsSinceEpoch(
          (json[flashSaleUntilField] is Timestamp
                  ? json[flashSaleUntilField].seconds
                  : json[flashSaleUntilField]['_seconds']) *
              1000,
        );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      flashSaleUntilField: Timestamp.fromDate(flashSaleUntil),
      nameField: name,
      uniqueIdField: uniqueId,
    }..updateAll(
        (key, value) => value ?? FieldValue.delete(),
      );
    return result;
  }

  @override
  List<Object?> get props => [uniqueId, flashSaleUntil, name];

  @override
  bool get stringify => true;
}
