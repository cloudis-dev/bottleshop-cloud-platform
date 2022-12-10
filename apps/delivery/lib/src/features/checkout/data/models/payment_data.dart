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

enum PlatformType {
  web,
  mobile;

  static const kWeb = 'web';
  static const kMobile = 'mobile';

  @override
  String toString() {
    switch (this) {
      case PlatformType.web:
        return kWeb;
      case PlatformType.mobile:
        return kMobile;
    }
  }

  static PlatformType? fromCode(String code) {
    switch (code) {
      case kWeb:
        return web;
      case kMobile:
        return mobile;
      default:
        return null;
    }
  }
}

class PaymentData extends Equatable {
  final String orderNote;
  final String deliveryType;
  final PlatformType platformType;

  /// The url to redirect to in case of payment failure.
  final String cancelUrl;

  /// The url to redirect to in case of payment success.
  final String successUrl;

  const PaymentData({
    required this.orderNote,
    required this.deliveryType,
    required this.platformType,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  List<Object?> get props => [orderNote, deliveryType, platformType];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderNote': orderNote,
      'deliveryType': deliveryType,
      'cancelUrl': cancelUrl,
      'successUrl': successUrl,
      'platform': platformType.toString()
    };
  }
}
