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

import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/reset_password_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FirebaseAnalytics _getAnalytics(WidgetRef ref) =>
    ref.read<FirebaseAnalytics>(analyticsProvider);

Future<void> logEvent(
  WidgetRef ref,
  String name, {
  Map<String, dynamic>? params,
}) {
  return _getAnalytics(ref).logEvent(name: name, parameters: params);
}

Future<void> setCurrentScreen(WidgetRef ref, String name) {
  return _getAnalytics(ref).setCurrentScreen(screenName: name);
}

Future<void> setUserId(WidgetRef ref, String id) async {
  return _getAnalytics(ref).setUserId(id: id);
}

Future<void> logAddPaymentInfo(WidgetRef ref) async {
  return _getAnalytics(ref).logAddPaymentInfo();
}

Future<void> logAddToCart(WidgetRef ref, String itemId, String itemName,
    String itemCategory, int quantity) async {
      print('wrksss');
  return _getAnalytics(ref).logEvent(name: "addToCart", parameters: {
      itemId: itemId,
      itemName: itemName,
      itemCategory: itemCategory,
      quantity.toString(): quantity.toString()});
}

Future<void> logAddToWishlist(BuildContext context, String itemId,
    String itemName, String itemCategory, int quantity) async {
  /*return _getAnalytics(context).logAddToWishlist(
      itemId: itemId,
      itemName: itemName,
      itemCategory: itemCategory,
      quantity: quantity);*/
}

Future<void> logPurchase(WidgetRef ref, double value) async {
  return _getAnalytics(ref).logPurchase(value: value, currency: 'EUR');
}

Future<void> logViewItem(
  BuildContext context,
  String itemId,
  String itemName,
  String itemCategory,
) async {
  /*return _getAnalytics(context).logViewItem(
      itemId: itemId, itemCategory: itemCategory, itemName: itemName);*/
}

String analyticsNameExtractor(RouteSettings settings) {
  switch (settings.name) {
    // case AccountPage.routeName:
    //   return 'Account settings';
    // case OrdersPage.routeName:
    //   return 'Orders';
    // case OrderDetailPage.routeName:
    //   return 'Order detail';
    // case TermsConditionsPage.routeName:
    //   return 'Terms and conditions';
    // case TutorialView.routeName:
    //   return 'Tutorial';
    // case HelpPage.routeName:
    //   return 'Help and faq';
    case ResetPasswordView.routeName:
      return 'Reset password';
    // case CategoryProductsDetailPage.routeName:
    //   return 'Product categories';
    // case ProductDetailPage.routeName:
    //   return 'Product details';
    // case ShippingDetailsPage.routeName:
    //   return 'Shipping details';
    // case CheckoutPage.routeName:
    //   return 'Checkout';
    // case CheckoutDoneView.routeName:
    //   return 'Checkout done';
    default:
      return '${settings.name ?? 'Unspecified'} view';
  }
}
