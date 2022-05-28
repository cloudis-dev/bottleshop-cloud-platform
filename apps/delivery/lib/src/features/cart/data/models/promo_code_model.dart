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

import 'package:delivery/src/config/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PromoCodeModel extends Equatable {
  static const String codeField = 'code';
  static const String remainingUsesCountField = 'remaining_uses_count';
  static const String discountField = 'discount';
  static const String productRefField = 'product_ref';

  final String? uid;
  final String? code;
  final int? remainingUsesCount;
  final double? discount;
  final String productUniqueId;

  const PromoCodeModel({
    required this.uid,
    required this.code,
    required this.remainingUsesCount,
    required this.discount,
    required this.productUniqueId,
  });

  const PromoCodeModel.empty(this.productUniqueId)
      : uid = null,
        code = null,
        remainingUsesCount = null,
        discount = null;

  PromoCodeModel.fromJson(Map<String, dynamic> json, this.uid)
      : code = json[codeField],
        remainingUsesCount = json[remainingUsesCountField],
        discount = json[discountField],
        productUniqueId = (json[productRefField] as DocumentReferencel10n.id;

  Map<String, dynamic> toFirebaseJson() {
    return {
      codeField: code,
      remainingUsesCountField: remainingUsesCount,
      discountField: discount,
      productRefField: FirebaseFirestore.instance
          .collection(FirestoreCollections.productsCollection)
          .doc(productUniqueId),
    };
  }

  @override
  List<Object?> get props => [
        uid,
        code,
        remainingUsesCount,
        discount,
        productUniqueId,
      ];

  @override
  bool get stringify => true;
}
