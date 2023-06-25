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

class AppEnvironment {
  AppEnvironment._();

  static const cloudFunctionsRegion = 'asia-south1';
  static const facebookPermissions = ['public_profile', 'email'];
  static const googleSignInScopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
  ];
  static const appleSignInClientId = 'sk.bottleshop3veze.applesignin';

  static const termsPdfEndpoint =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2F';

  static String get appleSignInRedirectUri => const String.fromEnvironment(
      'APPLE_SIGN_IN_REDIRECT',
      defaultValue:
          'https://bottleshop3veze-delivery.firebaseapp.com/__/auth/handler');

  static String get stripePublishableKey =>
      const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');

  static String get vapidKey => const String.fromEnvironment('DEFINE_VAPID_KEY',
      defaultValue:
          'BKJD6AGTNjU2aHqCWSP-njCoaIMW-ONn6e8397J14m8BQ2Tq-sch2PPZFIsPxYM6847Q9ldtW90BXrLIDMyi3-E');
}
