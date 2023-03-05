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

  static const createStripeCustomer = 'createStripeCustomer';
  static const deleteAccount = 'deleteAccount';
  static const createCheckoutSession = 'createCheckoutSession';
  static const createCashOnDeliveryOrder = 'createCashOnDeliveryOrder';
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
  static const String promoCodesCollection = 'promo_codes';

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
const kAppStoreDownload = 'assets/images/app-store-download.png';
const kGooglePlayDownload = 'assets/images/google-play-download.png';
const kFacebookIcon = 'assets/images/facebook_icon.png';
const kInsagramIcon = 'assets/images/instagram_icon.png';
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
const kLandingImage1 = 'assets/images/landing_page_image1.png';
const kLandingImage2 = 'assets/images/landing_page_image2.png';
const kLandingImage3 = 'assets/images/landing_page_image3.png';
const kLandingImage1Mobile = 'assets/images/landing_page_image1_mobile.png';
const kLandingImage2Mobile = 'assets/images/landing_page_image2_mobile.png';
const kLandingImage3Mobile = 'assets/images/landing_page_image3_mobile.png';
const kBlackGradient2Mobile = 'assets/images/black_gradient2_mobile.png';
const kBlackGradient3Mobile = 'assets/images/black_gradient3_mobile.png';
const kBlackGradient4Mobile = 'assets/images/black_gradient4_mobile.png';
const kBtnArrow = 'assets/images/btn_arrow.png';
const kMobilePhoneIcon = 'assets/images/mobile_phone_icon.png';
const kExclusiveIcon = 'assets/images/exclusive_icon.png';
const kGiftsIcon = 'assets/images/gifts_icon.png';
const kCareIcon = 'assets/images/care_icon.png';
const kXIcon = 'assets/images/x_icon.png';
const kCouponIcon = 'assets/images/coupon_icon.png';
const kHeartIcon = 'assets/images/heart_icon.png';
const kShoppingCartIcon = 'assets/images/shopping_cart_icon.png';
const kWhiteCouponIcon = 'assets/images/white_coupon_icon.png';
const kWhiteHeartIcon = 'assets/images/white_heart_icon.png';
const kWhiteShoppingCartIcon = 'assets/images/white_shopping_cart_icon.png';
const kBelugaIcon = 'assets/images/beluga_icon.png';
const kDiplomaticoIcon = 'assets/images/diplomatico_icon.png';
const kMurrayMcDavidIcon = 'assets/images/murray_mcdavid_icon.png';
const kRemyMartinIcon = 'assets/images/remy_martin_icon.png';
const kBrandBackground = 'assets/images/brand_background.png';
const kWhiskeyBourbon = 'assets/images/whiskey_bourbon.png';
const kCognac = 'assets/images/cognac.png';
const kGin = 'assets/images/gin.png';
const kRum = 'assets/images/rum.png';
const kVodka = 'assets/images/vodka.png';
const kApp = 'assets/images/app.png';
const kAppBackground = 'assets/images/white_background_app.png';
const kAppStoreBadgeEn = 'assets/images/app_store_badge_en.png';
const kAppStoreBadgeSk = 'assets/images/app_store_badge_sk.png';
const kGooglePlayBadgeSk = 'assets/images/google_play_badge_sk.png';
const kGooglePlayBadgeEn = 'assets/images/google_play_badge_en.png';

const double productImageAspectRatio = 12 / 16;
const double kTabBarHeight = 50.0;
const double kBottomBarItemsHeight = 42.0;

const kSplashBackground = Color(0xFF222224);

const kLanguageFlagsMap = {
  LanguageMode.en: 'assets/images/us.svg',
  LanguageMode.sk: 'assets/images/sk.svg',
};

class UrlStrings {
  static const String googlePlay =
      "https://play.google.com/store/apps/details?id=sk.bottleshop3veze.bottleshopdeliveryapp";
  static const String appStore = "https://apps.apple.com/app/id1509090326";
  static const String facebook = "https://www.facebook.com/bottleshop3veze";
  static const String instagram =
      "https://www.instagram.com/bottleshop3veze/?igshid=YmMyMTA2M2Y%3D";
  static const String shippingPaymentSK =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2FDoprava%20a%20platba.jpg?alt=media&token=8cc04823-19a8-4965-b1dc-8c28fe6a61ed';
  static const String shippingPaymentEN =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2FShipping%20and%20payment.jpg?alt=media&token=6b6e82b6-5a3e-4943-a76f-1d9071f38b7b';
  static const String privacyPolicySK =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2Ftcs_sk.pdf?alt=media#page=9';
  static const String privacyPolicyEN =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2Ftcs_en.pdf?alt=media#page=9';
  static const String menuTermsSK =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2Ftcs_sk.pdf?alt=media';
  static const String menuTermsEN =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2Ftcs_en.pdf?alt=media';
  static const String wholesaleSK =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2FVelkoobchod.pdf?alt=media&token=51cd0f1a-bd38-49df-9a21-c00a664278df';
  static const String wholesaleEN =
      'https://firebasestorage.googleapis.com/v0/b/bottleshop3veze-delivery.appspot.com/o/assets%2Fpdf%2FWholesale.pdf?alt=media&token=0a1f02c1-f9d5-4c86-bd23-caf68e4fc6fb';
}

class categoryUidStrings {
  static const rum = 'Z1ytjymiF5bTYemzxXox';
  static const whiskey = 'yvv9lwUbzEzrIGsZUZ2R';
  static const cognac = 'P77ijvW0x9AYvNbtwPc5';
  static const vodka = 'IKn86eYTxNcmba2huYEV';
  static const gin = 'I52jUD7D9sj6l0YsHbrk';
}
