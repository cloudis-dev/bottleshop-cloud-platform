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

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  AppEnvironment._();

  static const stripeSupportedCards = [
    'american_express',
    'visa',
    'electron',
    'maestro',
    'master_card',
  ];

  static const cloudFunctionsRegion = 'europe-west1';
  static const facebookPermissions = ['public_profile', 'email'];
  static const googleSignInScopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
  ];
  static const appleSignInClientId = 'sk.bottleshop3veze.applesignin';
  static const applePayMerchantId =
      'merchant.sk.bottleshop3veze.bottleshopdeliveryapp';
  static const termsPdfEndpoint =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2F';

  static String get appleSignInRedirectUri =>
      dotenv.env['DEFINE_APPLE_SIGN_IN_REDIRECT'] ??
      'https://bottleshop3veze-delivery.firebaseapp.com/__/auth/handler';

  static String get stripePublishableKey =>
      dotenv.env['DEFINE_STRIPE_KEY'] ??
      'pk_live_fRyyZgnqIu9Ry0YtvIpdv6pJ008KDasBdf';

  static String get stripeAndroidPayMode =>
      dotenv.env['DEFINE_ANDROID_PAY_MODE'] ?? 'development';

  static String get vapidKey =>
      dotenv.env['DEFINE_VAPID_KEY'] ??
      'BKJD6AGTNjU2aHqCWSP-njCoaIMW-ONn6e8397J14m8BQ2Tq-sch2PPZFIsPxYM6847Q9ldtW90BXrLIDMyi3-E';

  static const devFirebaseAuthPort = 9000;
  static const devFirestorePort = 8000;
  static const devFunctionsPort = 5001;
}
