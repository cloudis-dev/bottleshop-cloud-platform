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
import 'package:equatable/equatable.dart';

class PaymentData extends Equatable {
  final String? userId;
  final String? customerId;
  final String? email;
  final String? orderNote;
  final String? deliveryType;

  const PaymentData({
    required this.userId,
    required this.customerId,
    required this.email,
    required this.orderNote,
    required this.deliveryType,
  });

  @override
  List<Object?> get props => [
        userId,
        customerId,
        email,
        orderNote,
        deliveryType,
      ];

  @override
  bool get stringify => true;

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      userId: map['userId'] as String?,
      customerId: map['customerId'] as String?,
      email: map['email'] as String?,
      orderNote: map['orderNote'] as String?,
      deliveryType: map['deliveryType'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'customerId': customerId,
      'email': email,
      'orderNote': orderNote,
      'deliveryType': deliveryType,
    };
  }
}
