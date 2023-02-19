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

import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CloudFunctionsService).toString());

class CloudFunctionsService {
  final FirebaseFunctions _firebaseFunctions;

  CloudFunctionsService(FirebaseFunctions instance)
      : _firebaseFunctions = instance;

  Future<bool> deleteAccount() async {
    final res = await _firebaseFunctions
        .httpsCallable(FirebaseCallableFunctions.deleteAccount)
        .call<dynamic>();

    return res.data['success'] as bool;
  }

  Future<bool> postFeedback(Map<String, Object> data) async {
    final res = await _firebaseFunctions
        .httpsCallable(FirebaseCallableFunctions.postFeedback)
        .call<dynamic>(data);

    return true;
  }


  HttpsCallable createPaymentIntent() {
    return _firebaseFunctions
        .httpsCallable(FirebaseCallableFunctions.createPaymentIntent);
  }

  Future<String> createCheckoutSession({
    required String successUrl,
    required String cancelUrl,
  }) async {
    final response = await _firebaseFunctions
        .httpsCallable(FirebaseCallableFunctions.createCheckoutSession)
        .call<dynamic>(
      {
        "cancel_url": cancelUrl,
        "success_url": successUrl,
      },
    );
    return response.data;
  }

  Future<String> createStripePriceIds(StripeSessionRequest sessionReq) async {
  Future<String?> createCheckoutSession(PaymentData paymentData) async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createCheckoutSession)
          .call<dynamic>(paymentData.toMap());
      return response.data;
    } catch (err, stack) {
      _logger.severe("Failed to create checkout session $err", stack);
      return null;
    }
  }

  Future<String?> createStripeCustomer(UserModel user) async {
    try {
      final stripeCustomer = StripeCustomer.fromUser(user);
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createStripeCustomer)
          .call<dynamic>(stripeCustomer.toMap());
      return response.data['stripeCustomerId'];
    } catch (e, stack) {
      _logger.severe('Failed to create stripe customer', e, stack);
      return null;
    }
  }

  Future<void> createCashOnDeliveryOrder(PaymentData paymentData) async {
    try {
      await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createCashOnDeliveryOrder)
          .call<dynamic>(paymentData.toMap());
      _logger.fine('create cash-on-delivery order success.');
    } catch (e, stack) {
      _logger.severe('Failed to create cash-on-delivery order', e, stack);
      rethrow;
    }
  }
}

enum CartStatus { ok, unavailableProducts, invalidPromo, error }
