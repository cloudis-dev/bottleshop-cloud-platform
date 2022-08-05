import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class WalletsAvailability {
  final bool appleSignInAvailable;
  final bool applePayAvailable;
  final bool googlePayAvailable;

  const WalletsAvailability(
      {required this.appleSignInAvailable, required this.applePayAvailable, required this.googlePayAvailable});

  static Future<WalletsAvailability> check() async {
    if (kIsWeb) {
      return const WalletsAvailability(
          appleSignInAvailable: false, applePayAvailable: false, googlePayAvailable: false);
    }
    var isSignInAvailable = await SignInWithApple.isAvailable();
    var isApplePayAvailable = Stripe.instance.isApplePaySupported.value;
    var isGpayAvailable = await Stripe.instance.isGooglePaySupported(
        const IsGooglePaySupportedParams(testEnv: kDebugMode, existingPaymentMethodRequired: true));
    return WalletsAvailability(
        appleSignInAvailable: isSignInAvailable,
        applePayAvailable: isApplePayAvailable,
        googlePayAvailable: isGpayAvailable);
  }
}

final walletsAvailableProvider = Provider<WalletsAvailability>((ref) => throw UnimplementedError());
