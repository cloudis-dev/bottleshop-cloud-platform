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

import 'package:delivery/src/core/data/services/stripe_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/cart/data/repositories/cart_repository.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CheckoutState).toString());

final isRedirectingProvider = StateProvider.autoDispose<bool>((ref) => false);

final nativePayProvider = FutureProvider<bool>((ref) async {
  final stripe = ref.watch(stripeProvider);
  final isNativePayAvailable = await stripe.checkIfNativePayReady();
  return isNativePayAvailable;
});

final checkoutStateProvider = ChangeNotifierProvider.autoDispose((ref) {
  final cartService = ref.watch(cartRepositoryProvider)!;
  final stripeService = ref.watch(stripeProvider);
  return CheckoutState(stripeService: stripeService, cartService: cartService);
});

class CheckoutState extends ChangeNotifier {
  final StripeService stripeService;
  final CartRepository cartService;
  bool _isLoading = false;

  CheckoutState({required this.stripeService, required this.cartService});

  bool get isLoading => _isLoading;

  Future<void> payByNativePay(PaymentData paymentData) async {
    _logger.fine('payByNativePay invoked');
    _isLoading = true;
    notifyListeners();
    try {
      final canPayNatively = await stripeService.checkIfNativePayReady();
      if (canPayNatively) {
        _logger.fine('native pay supported');
        final cart = (await cartService.getCartModel())!;
        _logger.fine('cart retrieved: ${cart.toString()}');
        final items = await cartService.cartContent.first;
        _logger.fine('items retrieved: ${items.length}');
        await stripeService.payByNative(
          cart: cart,
          items: items,
          paymentData: paymentData,
        );
      } else {
        throw Exception('native pay not supported');
      }
    } on PlatformException catch (err, stack) {
      _logger.severe('Failed to pay by native PlatformException', err, stack);
      rethrow;
    } catch (err, stack) {
      _logger.severe('Failed to pay by native', err, stack);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> payByCreditCard(PaymentData paymentData) async {
    _isLoading = true;
    notifyListeners();
    _logger.fine('payByCreditCard invoked');
    try {
      await stripeService.payByCard(paymentData);
    } catch (err, stack) {
      _logger.severe('Failed to pay by credit card', err, stack);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
