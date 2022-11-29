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
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/checkout/data/models/stripe_session_request.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
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

  Future<bool> postFeedback() async {
    final res = await _firebaseFunctions
        .httpsCallable(FirebaseCallableFunctions.postFeedback)
        .call<dynamic>();

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
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createStripePriceIds)
          .call<dynamic>(sessionReq.toMap());
      _logger.info('response: ${response.data}');
      var responseData = response.data;
      String id = responseData['id'];
      return id;
    } catch (e, stack) {
      _logger.severe('Failed to create stripe customer', e, stack);
      return '';
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

  Future<String?> createCashOnDeliveryOrder(PaymentData paymentData) async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createCashOnDeliveryOrder)
          .call<dynamic>(paymentData.toMap());
      _logger.fine('createOrder: ${response.data}');
      return response.data['orderId'];
    } catch (e, stack) {
      _logger.severe('Failed to create cash on delivery order', e, stack);
      return null;
    }
  }

  Future<void> setShippingFee(DeliveryOption? deliveryOption) async {
    try {
      final shippingFee = ChargeShipping.fromDeliveryOption(deliveryOption);
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.setShippingFee)
          .call<dynamic>(shippingFee.toMap());
      _logger.fine('chargeShipping: ${response.data}');
    } catch (e, stack) {
      _logger.severe('unable to set shipping fee', e, stack);
    }
  }

  Future<void> removeShippingFee() async {
    _logger.fine('removeShippingFee invoked');
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.removeShippingFee)
          .call<dynamic>({'shipping': false});
      _logger.fine('removeShipping: ${response.data}');
    } catch (e, stack) {
      _logger.severe('unable to remove shipping fee', e, stack);
    }
  }

  Future<bool> addPromoCode(String promoCode) async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.addPromoCode)
          .call<dynamic>(<String, dynamic>{'promo': promoCode});
      _logger.fine('response: ${response.data['applied']}');
      return response.data['applied'];
    } catch (e, stack) {
      _logger.severe('unable to add promo', e, stack);
      return false;
    }
  }

  Future<CartStatus> validateCart() async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.validateCart)
          .call<dynamic>();
      switch (response.data['status']) {
        case 'ok':
          return CartStatus.ok;
        case 'invalid-promo':
          return CartStatus.invalidPromo;
        case 'unavailable-products':
          return CartStatus.unavailableProducts;
        default:
          return CartStatus.error;
      }
    } catch (e, stack) {
      _logger.severe('unable to validate cart', e, stack);
      return CartStatus.error;
    }
  }

  Future<bool> removePromoCode() async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.removePromoCode)
          .call<dynamic>((<String, dynamic>{'promo': false}));
      _logger.fine('response: ${response.data['applied']}');
      return response.data['applied'];
    } catch (e, stack) {
      _logger.severe('unable to remove promo', e, stack);
      return false;
    }
  }
}

enum CartStatus { ok, unavailableProducts, invalidPromo, error }
