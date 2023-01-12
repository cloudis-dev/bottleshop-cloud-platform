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

import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';

class StripeService {
  late final CloudFunctionsService _cloudFunctionsService;

  StripeService(CloudFunctionsService cloudFunctionsService)
      : _cloudFunctionsService = cloudFunctionsService {
    _cloudFunctionsService.toString();
  }

  Future<bool> checkIfNativePayReady() async {
    /*var deviceSupportNativePay =
        await (StripePayment.deviceSupportsNativePay() as FutureOr<bool>);
    var isNativeReady = await StripePayment.canMakeNativePayPayments(
        AppEnvironment.stripeSupportedCards);
    return deviceSupportNativePay && isNativeReady!;*/
    return false;
  }

  Future<void> payByNative({
    required CartModel cart,
    required List<CartItemModel> items,
    required PaymentData paymentData,
  }) async {
    /* var googlePayItems = <LineItem>[];
    items.forEach((item) {
      googlePayItems.add(LineItem(
        currencyCode: 'EUR',
        description: item.product.name,
        quantity: item.count.toString(),
        totalPrice: (item.product.priceWithVat * item.count).toStringAsFixed(2),
        unitPrice: item.product.priceWithVat.toStringAsFixed(2),
      ));
    });
    var applePayItems = <ApplePayItem>[]
      ..add(ApplePayItem(label: 'Bottleshop3veže, s.r.o', amount: cart.totalCartValue.toString()));
    var token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: cart.totalCartValue.toString(),
        currencyCode: 'EUR',
        lineItems: googlePayItems,
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'SK',
        currencyCode: 'EUR',
        items: applePayItems,
      ),
    );
    var paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    if (paymentMethod.id != null) {
      var intent =
          await _cloudFunctionsService.createPaymentIntent().call<dynamic>(paymentData.toMap());
      var result = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: intent.data['client_secret'], paymentMethodId: paymentMethod.id));
      _logger.d('paymentIntent statue: ${result.status}');
      if (result.status == 'succeeded') {
        await StripePayment.completeNativePayRequest();
      } else {
        await StripePayment.cancelNativePayRequest();
        throw ErrorCode(errorCode: result.status!, description: 'Payment failed');
      }
    } else {
      throw ErrorCode(
          errorCode: 'createMethod',
          description:
              'It is not possible to pay with this card. Please try again with a different card');
    }*/
    throw ErrorCode(
        errorCode: 'createMethod',
        description:
            'It is not possible to pay with this card. Please try again with a different card');
  }

  Future<void> payByCard(PaymentData paymentData) async {
    /*var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
    if (paymentMethod.id != null) {
      final intent =
          await _cloudFunctionsService.createPaymentIntent().call<dynamic>(paymentData.toMap());
      var result = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            clientSecret: intent.data['client_secret'], paymentMethodId: paymentMethod.id),
      );
      _logger.d('result: ${result.status}');
    } else {
      throw ErrorCode(
          errorCode: 'createMethod',
          description:
              'It is not possible to pay with this card. Please try again with a different card');
    }*/
    throw ErrorCode(
        errorCode: 'createMethod',
        description:
            'It is not possible to pay with this card. Please try again with a different card');
  }
}

class ErrorCode {
  late final String errorCode;
  late final String description;

  ErrorCode({required this.errorCode, required this.description});
}
