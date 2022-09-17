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

import 'dart:ui';

import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/features/tutorial/data/models/tutorial_model.dart';

class AppPreferencesKeys {
  AppPreferencesKeys._();

  static const preferencesThemeMode = 'theme_mode';
  static const preferencesLanguage = 'language';
  static const preferencesLayoutMode = 'layout_mode';
  static const preferencesTermsAgreed = 'terms_agreed';
  static const hasAgeVerified = 'has_age_verified';
}

class FirebaseCallableFunctions {
  FirebaseCallableFunctions._();

  static const createPaymentIntent = 'createPaymentIntent';
  static const createStripeCustomer = 'createStripeCustomer';
  static const setShippingFee = 'setShippingFee';
  static const removeShippingFee = 'removeShippingFee';
  static const addPromoCode = 'applyPromoCode';
  static const validateCart = 'validateCart';
  static const removePromoCode = 'removePromoCode';
  static const createStripePriceIds = 'createStripePriceIds';
  static const createCashOnDeliveryOrder = 'createCashOnDeliveryOrder';
  static const deleteAccount = 'deleteAccount';
}

class FirestoreCollections {
  FirestoreCollections._();

  static const String usersCollection = 'users';
  static const String userDevicesSubCollection = 'devices';
  static const String userWishListSubCollection = 'wishlist';
  static const String userCartSubCollection = 'cart';
  static const String userCartContentSubCollection = 'items';

  static const String appSettingsCollection = 'configuration';

  static const String productsCollection = 'warehouse';
  static const String flashSalesCollection = 'flash_sales';
  static const String categoriesCollection = 'categories';
  static const String countriesCollection = 'countries';
  static const String shoppingCartsCollection = 'carts';
  static const String unitsCollection = 'units';
  static const String orderTypesCollection = 'order_types';
  static const String ordersCollection = 'orders';
  static const String versionConstraintsCollection = 'version_constraints';

  static const String slidersSubCollection = 'configuration/sliders/data';
  static const String aggregationsCollection = 'aggregations';

  // document constants
  static const String filtersAggregationsDocument = 'filters';
  static const String categoryProductCountsAggregationsDocument =
      'products_count_per_categories';
  static const String userCartId = 'temp_cart';
}

class FirestorePaths {
  FirestorePaths._();

  static String userDevices(String uid) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userDevicesSubCollection}';

  static String userDevice(String uid, String deviceId) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userDevicesSubCollection}/$deviceId';

  static String userFavorites(String uid) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userWishListSubCollection}';

  static String userFavorite(String uid, String productId) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userWishListSubCollection}/$productId';

  static String userCart(String uid) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userCartSubCollection}';

  static String userCartContent(String uid) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userCartSubCollection}/${FirestoreCollections.userCartId}/${FirestoreCollections.userCartContentSubCollection}';

  static String userCartItem(String uid, String productId) =>
      '${FirestoreCollections.usersCollection}/$uid/${FirestoreCollections.userCartSubCollection}/$productId';
}

class HeroTags {
  HeroTags._();

  static const searchTag = 'search';
  static const productBaseTag = 'product';
}

class TutorialAssets {
  static const assets = [
    TutorialModel(
      heroAsset: 'assets/images/onboarding-phone.webp',
      labelAsset: 'assets/images/onboarding_text1.png',
    ),
    TutorialModel(
      heroAsset: 'assets/images/onboarding-person.webp',
      labelAsset: 'assets/images/onboarding_text2.webp',
    ),
    TutorialModel(
      heroAsset: 'assets/images/onboarding-glasses.webp',
      labelAsset: 'assets/images/onboarding_text3.webp',
    ),
  ];
  static const boardingLogo = 'assets/images/onboarding-logo.webp';
}

class AppAnalyticsEvents {
  static const String logOut = 'log_out';
}

class AnalyticsScreenNames {
  static const String welcome = 'Welcome page';
  static const String splash = 'Splash screen';
  static const String login = 'Login Screen';
  static const String userInfo = 'User profile';
  static const String root = 'Root page';
}

const kLogo = 'assets/images/onboarding-logo.webp';
const kDefaultAvatar = 'assets/images/avatar.webp';
const kDefaultProductPic = 'assets/images/default_product.webp';
const kDefaultProductPicDark = 'assets/images/default_product_dark.webp';
const kSpecialEdition = 'assets/images/special.png';
const kAppIcon = 'assets/images/app-icon.png';
const kSplash = 'assets/images/splash.webp';
const kSplashLandscape = 'assets/images/splash-landscape.webp';
const kAlgoliaLogo = 'assets/images/search-by-algolia-light-background.webp';
const kAlgoliaLogoDark = 'assets/images/search-by-algolia-dark-background.webp';
const kFaqMd = 'assets/markdown/faq_en.md';
const kContactsMd = 'assets/markdown/contact_details_en.md';
const kFaqMdLocalized = 'assets/markdown/faq_sk.md';
const kContactsMdLocalized = 'assets/markdown/contact_details_sk.md';
const kApplePayBtn = 'assets/images/apple_pay_white.png';
const kApplePayBtnDark = 'assets/images/apple_pay_black.png';
const kApplePayMark = 'assets/images/apple_pay_mark.png';
const kGooglePayBtn = 'assets/images/g_pay_white.png';
const kGooglePayBtnDark = 'assets/images/g_pay_black.png';
const kGooglePayMark = 'assets/images/g_pay_mark.png';
const kMasterCardPayBtn = 'assets/images/mastercard_light.png';
const kMasterCardBtnDark = 'assets/images/mastercard_dark.png';
const kVisaBtn = 'assets/images/visa_white.png';
const kVisaBtnDark = 'assets/images/visa_black.png';
const kMaestroBtn = 'assets/images/maestro.png';
const kMaestroBtnDark = 'assets/images/maestro_dark.png';
const kDinersBtn = 'assets/images/diners_white.png';
const kAmex = 'assets/images/amex.png';
const kLogoTransparent = 'assets/images/logo_transparent.png';

const double productImageAspectRatio = 12 / 16;
const double kTabBarHeight = 50.0;
const double kBottomBarItemsHeight = 42.0;

const kSplashBackground = Color(0xFF222224);

const kLanguageFlagsMap = {
  LanguageMode.en: 'assets/images/us.svg',
  LanguageMode.sk: 'assets/images/sk.svg',
};

const kOrderTypePickUp = 'pick-up';
const kOrderTypeHomeDelivery = 'home-delivery';
const kOrderTypeQuickBa = 'quick-delivery-BA';
const kOrderTypeCloseAreaBa = 'close-areas-delivery-ba';
const kOrderTypeCashOnDelivery = 'cash-on-delivery';
