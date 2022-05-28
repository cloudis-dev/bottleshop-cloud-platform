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

import 'dart:async';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class PaymentServices {
  Future<void> presentApplePay();
  Future<void> confirmApplePayPayment();

  Future<SetupIntent> confirmSetupIntent();
  Future<PaymentIntent> retrievePaymentIntent();

  Future<void> initPaymentSheet();
  Future<void> presentPaymentSheet();
  Future<void> confirmPaymentSheetPayment();
}

class StripeService implements PaymentServices {
  final Reader read;
  const StripeService(this.read);

  @override
  Future<void> confirmApplePayPayment() {
    // TODO: implement confirmApplePayPayment
    throw UnimplementedError();
  }

  @override
  Future<void> confirmPaymentSheetPayment() {
    // TODO: implement confirmPaymentSheetPayment
    throw UnimplementedError();
  }

  @override
  Future<SetupIntent> confirmSetupIntent() {
    // TODO: implement confirmSetupIntent
    throw UnimplementedError();
  }

  @override
  Future<void> initPaymentSheet() {
    // TODO: implement initPaymentSheet
    throw UnimplementedError();
  }

  @override
  Future<void> presentApplePay() {
    // TODO: implement presentApplePay
    throw UnimplementedError();
  }

  @override
  Future<void> presentPaymentSheet() {
    // TODO: implement presentPaymentSheet
    throw UnimplementedError();
  }

  @override
  Future<PaymentIntent> retrievePaymentIntent() {
    // TODO: implement retrievePaymentIntent
    throw UnimplementedError();
  }
}
