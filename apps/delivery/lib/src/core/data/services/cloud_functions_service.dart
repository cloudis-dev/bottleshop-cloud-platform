import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class CloudFunctionsService with NetworkLoggy {
  final FirebaseFunctions _firebaseFunctions;

  CloudFunctionsService(FirebaseFunctions instance) : _firebaseFunctions = instance;

  Future<bool> deleteAccount() async {
    final res = await _firebaseFunctions.httpsCallable(FirebaseCallableFunctions.deleteAccount).call<dynamic>();

    return res.data['success'] as bool;
  }

  HttpsCallable createPaymentIntent() {
    return _firebaseFunctions.httpsCallable(FirebaseCallableFunctions.createPaymentIntent);
  }

  Future<String?> createStripeCustomer(UserModel user) async {
    try {
      final stripeCustomer = StripeCustomer.fromUser(user);
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createStripeCustomer)
          .call<dynamic>(stripeCustomer.toMap());
      loggy.debug('createStripeCustomer: ${response.data}');
      return response.data['stripeCustomerId'];
    } catch (e, stack) {
      loggy.error('Failed to create stripe customer', e, stack);
      return null;
    }
  }

  Future<String?> createCashOnDeliveryOrder(PaymentData paymentData) async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.createCashOnDeliveryOrder)
          .call<dynamic>(paymentData.toMap());
      loggy.debug('createOrder: ${response.data}');
      return response.data['orderId'];
    } catch (e, stack) {
      logError('Failed to create cash on delivery order', e, stack);
      return null;
    }
  }

  Future<void> setShippingFee(DeliveryOption? deliveryOption) async {
    try {
      final shippingFee = ChargeShipping.fromDeliveryOption(deliveryOption);
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.setShippingFee)
          .call<dynamic>(shippingFee.toMap());
      loggy.debug('chargeShipping: ${response.data}');
    } catch (e, stack) {
      loggy.error('unable to set shipping fee', e, stack);
    }
  }

  Future<void> removeShippingFee() async {
    logInfo('removeShippingFee invoked');
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.removeShippingFee)
          .call<dynamic>({'shipping': false});
      loggy.debug('removeShipping: ${response.data}');
    } catch (e, stack) {
      loggy.error('unable to remove shipping fee', e, stack);
    }
  }

  Future<bool> addPromoCode(String promoCode) async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.addPromoCode)
          .call<dynamic>(<String, dynamic>{'promo': promoCode});
      logInfo('response: ${response.data['applied']}');
      return response.data['applied'];
    } catch (e, stack) {
      logError('unable to add promo', e, stack);
      return false;
    }
  }

  Future<CartStatus> validateCart() async {
    try {
      final response = await _firebaseFunctions.httpsCallable(FirebaseCallableFunctions.validateCart).call<dynamic>();
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
      logError('unable to validate cart', e, stack);
      return CartStatus.error;
    }
  }

  Future<bool> removePromoCode() async {
    try {
      final response = await _firebaseFunctions
          .httpsCallable(FirebaseCallableFunctions.removePromoCode)
          .call<dynamic>((<String, dynamic>{'promo': false}));
      logInfo('response: ${response.data['applied']}');
      return response.data['applied'];
    } catch (e, stack) {
      logError('unable to remove promo', e, stack);
      return false;
    }
  }
}

enum CartStatus { ok, unavailableProducts, invalidPromo, error }

final cloudFunctionsProvider = Provider<CloudFunctionsService>(((ref) => throw UnimplementedError()));
