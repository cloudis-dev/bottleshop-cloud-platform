// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About us`
  String get aboutUs {
    return Intl.message(
      'About us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get account_already {
    return Intl.message(
      'Already have an account?',
      name: 'account_already',
      desc: '',
      args: [],
    );
  }

  /// `Add another country`
  String get addAnotherCountry {
    return Intl.message(
      'Add another country',
      name: 'addAnotherCountry',
      desc: '',
      args: [],
    );
  }

  /// `added to cart`
  String get addedToCart {
    return Intl.message(
      'added to cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `added to favorites`
  String get addedToWishList {
    return Intl.message(
      'added to favorites',
      name: 'addedToWishList',
      desc: '',
      args: [],
    );
  }

  /// `Delivery remarks`
  String get additionalRemarks {
    return Intl.message(
      'Delivery remarks',
      name: 'additionalRemarks',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart`
  String get add_to_cart {
    return Intl.message(
      'Add to cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Age (years)`
  String get ageYears {
    return Intl.message(
      'Age (years)',
      name: 'ageYears',
      desc: '',
      args: [],
    );
  }

  /// `Alcohol content`
  String get alcohol {
    return Intl.message(
      'Alcohol content',
      name: 'alcohol',
      desc: '',
      args: [],
    );
  }

  /// `Alcohol content:`
  String get alcoholContent {
    return Intl.message(
      'Alcohol content:',
      name: 'alcoholContent',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `All products`
  String get allProducts {
    return Intl.message(
      'All products',
      name: 'allProducts',
      desc: '',
      args: [],
    );
  }

  /// `Amount is incorrect`
  String get amount_incorrect {
    return Intl.message(
      'Amount is incorrect',
      name: 'amount_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Used for Bottleshop3veže order notifications`
  String get androidNotificationChannelDescription {
    return Intl.message(
      'Used for Bottleshop3veže order notifications',
      name: 'androidNotificationChannelDescription',
      desc: '',
      args: [],
    );
  }

  /// `Orders notification`
  String get androidNotificationChannelTitle {
    return Intl.message(
      'Orders notification',
      name: 'androidNotificationChannelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get anonymousUser {
    return Intl.message(
      'Anonymous',
      name: 'anonymousUser',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguageLabel {
    return Intl.message(
      'App Language',
      name: 'appLanguageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Application Preferences`
  String get applicationPreferences {
    return Intl.message(
      'Application Preferences',
      name: 'applicationPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Application Preferences`
  String get app_preferences {
    return Intl.message(
      'Application Preferences',
      name: 'app_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Bottleshop3veže`
  String get app_title {
    return Intl.message(
      'Bottleshop3veže',
      name: 'app_title',
      desc: 'Main title',
      args: [],
    );
  }

  /// `Bajkalska`
  String get bajkalska {
    return Intl.message(
      'Bajkalska',
      name: 'bajkalska',
      desc: '',
      args: [],
    );
  }

  /// `Billing address`
  String get billingAddress {
    return Intl.message(
      'Billing address',
      name: 'billingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message(
      'Birth Date',
      name: 'birthDate',
      desc: '',
      args: [],
    );
  }

  /// `Bratislava`
  String get bratislava {
    return Intl.message(
      'Bratislava',
      name: 'bratislava',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message(
      'Cancel',
      name: 'cancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Card payment error`
  String get cardPaymentError {
    return Intl.message(
      'Card payment error',
      name: 'cardPaymentError',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Check your email and follow the instructions to reset your password`
  String get checkYourEmailAndFollowTheInstructionsToResetYour {
    return Intl.message(
      'Check your email and follow the instructions to reset your password',
      name: 'checkYourEmailAndFollowTheInstructionsToResetYour',
      desc: '',
      args: [],
    );
  }

  /// `Check your email for password reset instructions`
  String get checkYourEmailForPasswordResetInstructions {
    return Intl.message(
      'Check your email for password reset instructions',
      name: 'checkYourEmailForPasswordResetInstructions',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `City is required`
  String get cityIsRequired {
    return Intl.message(
      'City is required',
      name: 'cityIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clear_all {
    return Intl.message(
      'Clear All',
      name: 'clear_all',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clearButton {
    return Intl.message(
      'Clear',
      name: 'clearButton',
      desc: '',
      args: [],
    );
  }

  /// `CLOSE`
  String get close {
    return Intl.message(
      'CLOSE',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Developer: AVE-Z s.r.o.\nYear: 2021\nEmail: info@ave-z.com`
  String get companyAndYear {
    return Intl.message(
      'Developer: AVE-Z s.r.o.\nYear: 2021\nEmail: info@ave-z.com',
      name: 'companyAndYear',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation email was sent`
  String get confirmationEmailSent {
    return Intl.message(
      'Confirmation email was sent',
      name: 'confirmationEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirm_payment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirm_payment',
      desc: '',
      args: [],
    );
  }

  /// `Pay with a card`
  String get confirmPayment {
    return Intl.message(
      'Pay with a card',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Contact details`
  String get contactDetails {
    return Intl.message(
      'Contact details',
      name: 'contactDetails',
      desc: '',
      args: [],
    );
  }

  /// `Contact information`
  String get contactInformation {
    return Intl.message(
      'Contact information',
      name: 'contactInformation',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't be added to the cart`
  String get couldntBeAddedToTheCart {
    return Intl.message(
      'Couldn\'t be added to the cart',
      name: 'couldntBeAddedToTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't be successfully added to wishlist`
  String get couldntBeSuccessfullyAddedToWishlist {
    return Intl.message(
      'Couldn\'t be successfully added to wishlist',
      name: 'couldntBeSuccessfullyAddedToWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't be successfully removed from wishlist`
  String get couldntBeSuccessfullyRemovedFromWishlist {
    return Intl.message(
      'Couldn\'t be successfully removed from wishlist',
      name: 'couldntBeSuccessfullyRemovedFromWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't change the quantity of the product in the cart`
  String get couldntChangeQuantityOfTheProductInTheCart {
    return Intl.message(
      'Couldn\'t change the quantity of the product in the cart',
      name: 'couldntChangeQuantityOfTheProductInTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Countries`
  String get countries {
    return Intl.message(
      'Countries',
      name: 'countries',
      desc: '',
      args: [],
    );
  }

  /// `Country:`
  String get country {
    return Intl.message(
      'Country:',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created {
    return Intl.message(
      'Created',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message(
      'Dark mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Day of Birth`
  String get dayOfBirth {
    return Intl.message(
      'Day of Birth',
      name: 'dayOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivery options`
  String get deliveryOptions {
    return Intl.message(
      'Delivery options',
      name: 'deliveryOptions',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account yet?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account yet?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Download the update`
  String get downloadTheUpdate {
    return Intl.message(
      'Download the update',
      name: 'downloadTheUpdate',
      desc: '',
      args: [],
    );
  }

  /// `EAN:`
  String get ean {
    return Intl.message(
      'EAN:',
      name: 'ean',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message(
      'Email Address',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email is invalid`
  String get email_invalid {
    return Intl.message(
      'Email is invalid',
      name: 'email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailIsRequired {
    return Intl.message(
      'Email is required',
      name: 'emailIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `No items in your cart`
  String get emptyCart {
    return Intl.message(
      'No items in your cart',
      name: 'emptyCart',
      desc: '',
      args: [],
    );
  }

  /// `No items in the favorites`
  String get emptyWishList {
    return Intl.message(
      'No items in the favorites',
      name: 'emptyWishList',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get enterAValidEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'enterAValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid ZIP code`
  String get enterAValidZipCode {
    return Intl.message(
      'Enter a valid ZIP code',
      name: 'enterAValidZipCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid phone number`
  String get enterValidPhoneNumber {
    return Intl.message(
      'Enter valid phone number',
      name: 'enterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred`
  String get errorGeneric {
    return Intl.message(
      'Unexpected error occurred',
      name: 'errorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Extra categories`
  String get extraCategories {
    return Intl.message(
      'Extra categories',
      name: 'extraCategories',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch the cart`
  String get failedToFetchCart {
    return Intl.message(
      'Failed to fetch the cart',
      name: 'failedToFetchCart',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favoriteTabLabel {
    return Intl.message(
      'Favorites',
      name: 'favoriteTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Field is not empty`
  String get field_not_empty {
    return Intl.message(
      'Field is not empty',
      name: 'field_not_empty',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Filtered products`
  String get filteredProducts {
    return Intl.message(
      'Filtered products',
      name: 'filteredProducts',
      desc: '',
      args: [],
    );
  }

  /// `Flash Sale ended`
  String get flashSaleEnded {
    return Intl.message(
      'Flash Sale ended',
      name: 'flashSaleEnded',
      desc: '',
      args: [],
    );
  }

  /// `Flash Sales`
  String get flashSales {
    return Intl.message(
      'Flash Sales',
      name: 'flashSales',
      desc: '',
      args: [],
    );
  }

  /// `Flashsale until:`
  String get flashsaleUntil {
    return Intl.message(
      'Flashsale until:',
      name: 'flashsaleUntil',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Full name is required`
  String get fullNameIsRequired {
    return Intl.message(
      'Full name is required',
      name: 'fullNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Full name must be longer`
  String get fullNameMustBeLonger {
    return Intl.message(
      'Full name must be longer',
      name: 'fullNameMustBeLonger',
      desc: '',
      args: [],
    );
  }

  /// `Further details`
  String get furtherDetails {
    return Intl.message(
      'Further details',
      name: 'furtherDetails',
      desc: '',
      args: [],
    );
  }

  /// `General Commercial Terms`
  String get generalCommercialTermsTitle {
    return Intl.message(
      'General Commercial Terms',
      name: 'generalCommercialTermsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Got your new password?`
  String get gotNewPassword {
    return Intl.message(
      'Got your new password?',
      name: 'gotNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get help_support {
    return Intl.message(
      'Help & Support',
      name: 'help_support',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Hit the search!`
  String get hitTheSearch {
    return Intl.message(
      'Hit the search!',
      name: 'hitTheSearch',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get homeTabLabel {
    return Intl.message(
      'Shop',
      name: 'homeTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `in cart`
  String get inCart {
    return Intl.message(
      'in cart',
      name: 'inCart',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `In Dispute`
  String get in_dispute {
    return Intl.message(
      'In Dispute',
      name: 'in_dispute',
      desc: '',
      args: [],
    );
  }

  /// `in stock`
  String get inStock {
    return Intl.message(
      'in stock',
      name: 'inStock',
      desc: '',
      args: [],
    );
  }

  /// `In stock`
  String get inStockCount {
    return Intl.message(
      'In stock',
      name: 'inStockCount',
      desc: '',
      args: [],
    );
  }

  /// `Entrance, floor, others`
  String get instructionsForDelivery {
    return Intl.message(
      'Entrance, floor, others',
      name: 'instructionsForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Item removed from the cart`
  String get itemRemovedFromCart {
    return Intl.message(
      'Item removed from the cart',
      name: 'itemRemovedFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Item removed from favorites`
  String get itemRemovedFromWishList {
    return Intl.message(
      'Item removed from favorites',
      name: 'itemRemovedFromWishList',
      desc: '',
      args: [],
    );
  }

  /// `Items count`
  String get itemsCount {
    return Intl.message(
      'Items count',
      name: 'itemsCount',
      desc: '',
      args: [],
    );
  }

  /// `It is not possible to pay with this card. Please try again with a different card`
  String get itIsNotPossibleToPayWithThisCardPlease {
    return Intl.message(
      'It is not possible to pay with this card. Please try again with a different card',
      name: 'itIsNotPossibleToPayWithThisCardPlease',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `max`
  String get max {
    return Intl.message(
      'max',
      name: 'max',
      desc: '',
      args: [],
    );
  }

  /// `Misc`
  String get misc {
    return Intl.message(
      'Misc',
      name: 'misc',
      desc: '',
      args: [],
    );
  }

  /// `Modify filter`
  String get modifyFilter {
    return Intl.message(
      'Modify filter',
      name: 'modifyFilter',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message(
      'My Orders',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get na {
    return Intl.message(
      'N/A',
      name: 'na',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Name is invalid`
  String get name_invalid {
    return Intl.message(
      'Name is invalid',
      name: 'name_invalid',
      desc: '',
      args: [],
    );
  }

  /// `New additions`
  String get newAdditionToOurStock {
    return Intl.message(
      'New additions',
      name: 'newAdditionToOurStock',
      desc: '',
      args: [],
    );
  }

  /// `New Arrivals`
  String get newArrivals {
    return Intl.message(
      'New Arrivals',
      name: 'newArrivals',
      desc: '',
      args: [],
    );
  }

  /// `You do not have any ordered items`
  String get no_orders {
    return Intl.message(
      'You do not have any ordered items',
      name: 'no_orders',
      desc: '',
      args: [],
    );
  }

  /// `You do not have any ordered items`
  String get noOrders {
    return Intl.message(
      'You do not have any ordered items',
      name: 'noOrders',
      desc: '',
      args: [],
    );
  }

  /// `No items`
  String get noSuchItems {
    return Intl.message(
      'No items',
      name: 'noSuchItems',
      desc: '',
      args: [],
    );
  }

  /// `Delivery remarks`
  String get notes {
    return Intl.message(
      'Delivery remarks',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get notSet {
    return Intl.message(
      'Anonymous',
      name: 'notSet',
      desc: '',
      args: [],
    );
  }

  /// `Only following countries`
  String get onlyFollowingCountries {
    return Intl.message(
      'Only following countries',
      name: 'onlyFollowingCountries',
      desc: '',
      args: [],
    );
  }

  /// `Only following extra categories`
  String get onlyFollowingExtraCategories {
    return Intl.message(
      'Only following extra categories',
      name: 'onlyFollowingExtraCategories',
      desc: '',
      args: [],
    );
  }

  /// `Only special editions`
  String get onlySpecialEditions {
    return Intl.message(
      'Only special editions',
      name: 'onlySpecialEditions',
      desc: '',
      args: [],
    );
  }

  /// `Or via`
  String get or_checkout {
    return Intl.message(
      'Or via',
      name: 'or_checkout',
      desc: '',
      args: [],
    );
  }

  /// `Or via`
  String get orCheckoutWith {
    return Intl.message(
      'Or via',
      name: 'orCheckoutWith',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get orderCompleted {
    return Intl.message(
      'Completed',
      name: 'orderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get orderCreated {
    return Intl.message(
      'Created',
      name: 'orderCreated',
      desc: '',
      args: [],
    );
  }

  /// `Purchased items`
  String get orderedItems {
    return Intl.message(
      'Purchased items',
      name: 'orderedItems',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get orderReady {
    return Intl.message(
      'Ready',
      name: 'orderReady',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get orderShipping {
    return Intl.message(
      'Shipped',
      name: 'orderShipping',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orderTabLabel {
    return Intl.message(
      'Orders',
      name: 'orderTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Order type`
  String get orderType {
    return Intl.message(
      'Order type',
      name: 'orderType',
      desc: '',
      args: [],
    );
  }

  /// `Or using social media`
  String get or_social_media {
    return Intl.message(
      'Or using social media',
      name: 'or_social_media',
      desc: '',
      args: [],
    );
  }

  /// `Other category:`
  String get otherCategory {
    return Intl.message(
      'Other category:',
      name: 'otherCategory',
      desc: '',
      args: [],
    );
  }

  /// `Out of stock`
  String get outOfStock {
    return Intl.message(
      'Out of stock',
      name: 'outOfStock',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get password_forgotten {
    return Intl.message(
      'Forgot your password?',
      name: 'password_forgotten',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordIsRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The password must have at least 6 characters`
  String get passwordMinimumRequirementsHint {
    return Intl.message(
      'The password must have at least 6 characters',
      name: 'passwordMinimumRequirementsHint',
      desc: '',
      args: [],
    );
  }

  /// `Passwords doesn't match`
  String get password_no_match {
    return Intl.message(
      'Passwords doesn\'t match',
      name: 'password_no_match',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password is too short`
  String get password_short {
    return Intl.message(
      'Password is too short',
      name: 'password_short',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get paymentDetails {
    return Intl.message(
      'Details',
      name: 'paymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneNumberIsRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneNumberIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out your `
  String get pleaseFillOutYour {
    return Intl.message(
      'Please fill out your ',
      name: 'pleaseFillOutYour',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out your email, name and phone number`
  String get pleaseFillOutYourEmailAndName {
    return Intl.message(
      'Please fill out your email, name and phone number',
      name: 'pleaseFillOutYourEmailAndName',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out your billing and shipping address`
  String get pleaseFillOutYourEmailNameBillingAndShippingAddress {
    return Intl.message(
      'Please fill out your billing and shipping address',
      name: 'pleaseFillOutYourEmailNameBillingAndShippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Verification email was sent (check your SPAM folder)`
  String get pleaseVerifyYourEmail {
    return Intl.message(
      'Verification email was sent (check your SPAM folder)',
      name: 'pleaseVerifyYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message(
      'Preferences',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `Offered payment methods`
  String get preferred_payment {
    return Intl.message(
      'Offered payment methods',
      name: 'preferred_payment',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to checkout`
  String get proceedToCheckout {
    return Intl.message(
      'Proceed to checkout',
      name: 'proceedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to delivery`
  String get proceedToShipment {
    return Intl.message(
      'Proceed to delivery',
      name: 'proceedToShipment',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Product review`
  String get product_review {
    return Intl.message(
      'Product review',
      name: 'product_review',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Profile Settings`
  String get profileSettings {
    return Intl.message(
      'Profile Settings',
      name: 'profileSettings',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get profileUpdated {
    return Intl.message(
      'Profile updated',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get profileUpdatedMsg {
    return Intl.message(
      'Profile updated',
      name: 'profileUpdatedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Promo code applied`
  String get promoCodeApplied {
    return Intl.message(
      'Promo code applied',
      name: 'promoCodeApplied',
      desc: '',
      args: [],
    );
  }

  /// `To use the promo code, the price of that cart must be higher`
  String get promoCodeCartLow {
    return Intl.message(
      'To use the promo code, the price of that cart must be higher',
      name: 'promoCodeCartLow',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or already used up promo code`
  String get promoCodeInvalid {
    return Intl.message(
      'Invalid or already used up promo code',
      name: 'promoCodeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Promo`
  String get promoCodeLabel {
    return Intl.message(
      'Promo',
      name: 'promoCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Quick delivery is possible only in Bratislava`
  String get quickDeliveryIsPossibleOnlyInBratislava {
    return Intl.message(
      'Quick delivery is possible only in Bratislava',
      name: 'quickDeliveryIsPossibleOnlyInBratislava',
      desc: '',
      args: [],
    );
  }

  /// `Recommended by our staff`
  String get recommendedByOurStaff {
    return Intl.message(
      'Recommended by our staff',
      name: 'recommendedByOurStaff',
      desc: '',
      args: [],
    );
  }

  /// `Recommended For You`
  String get recommendedForYou {
    return Intl.message(
      'Recommended For You',
      name: 'recommendedForYou',
      desc: '',
      args: [],
    );
  }

  /// `Related Poducts`
  String get related_products {
    return Intl.message(
      'Related Poducts',
      name: 'related_products',
      desc: '',
      args: [],
    );
  }

  /// `Remaining days`
  String get remainingDays {
    return Intl.message(
      'Remaining days',
      name: 'remainingDays',
      desc: '',
      args: [],
    );
  }

  /// `Remaining hours`
  String get remainingHours {
    return Intl.message(
      'Remaining hours',
      name: 'remainingHours',
      desc: '',
      args: [],
    );
  }

  /// `Remaining minutes`
  String get remainingMinutes {
    return Intl.message(
      'Remaining minutes',
      name: 'remainingMinutes',
      desc: '',
      args: [],
    );
  }

  /// `To proceed, choose a delivery option`
  String get reminderChooseDelivery {
    return Intl.message(
      'To proceed, choose a delivery option',
      name: 'reminderChooseDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Remember: the order will be processed only during opening hours!`
  String get reminderOpeningHours {
    return Intl.message(
      'Remember: the order will be processed only during opening hours!',
      name: 'reminderOpeningHours',
      desc: '',
      args: [],
    );
  }

  /// `removed from favorites`
  String get removedFromWishList {
    return Intl.message(
      'removed from favorites',
      name: 'removedFromWishList',
      desc: '',
      args: [],
    );
  }

  /// `Re-send verification email`
  String get resendVerificationEmail {
    return Intl.message(
      'Re-send verification email',
      name: 'resendVerificationEmail',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveButton {
    return Intl.message(
      'Save',
      name: 'saveButton',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search again`
  String get searchAgain {
    return Intl.message(
      'Search again',
      name: 'searchAgain',
      desc: '',
      args: [],
    );
  }

  /// `Search products`
  String get searchProducts {
    return Intl.message(
      'Search products',
      name: 'searchProducts',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get selectCountry {
    return Intl.message(
      'Select country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery option`
  String get selectDeliveryOption {
    return Intl.message(
      'Select delivery option',
      name: 'selectDeliveryOption',
      desc: '',
      args: [],
    );
  }

  /// `Select your day of birth`
  String get selectYourDayOfBirth {
    return Intl.message(
      'Select your day of birth',
      name: 'selectYourDayOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Offered payment methods`
  String get selectYourPreferredPaymentMode {
    return Intl.message(
      'Offered payment methods',
      name: 'selectYourPreferredPaymentMode',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get shipped {
    return Intl.message(
      'Shipped',
      name: 'shipped',
      desc: '',
      args: [],
    );
  }

  /// `Shipping address`
  String get shippingAddress {
    return Intl.message(
      'Shipping address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Shipping fee`
  String get shippingFee {
    return Intl.message(
      'Shipping fee',
      name: 'shippingFee',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shopping_cart {
    return Intl.message(
      'Shopping Cart',
      name: 'shopping_cart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Sign in failed, please try again`
  String get sign_failure {
    return Intl.message(
      'Sign in failed, please try again',
      name: 'sign_failure',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Slovak`
  String get slovak {
    return Intl.message(
      'Slovak',
      name: 'slovak',
      desc: '',
      args: [],
    );
  }

  /// `Slovakia`
  String get slovakiaPlaceholder {
    return Intl.message(
      'Slovakia',
      name: 'slovakiaPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Some answers`
  String get someAnswers {
    return Intl.message(
      'Some answers',
      name: 'someAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Sort ascending`
  String get sortAscending {
    return Intl.message(
      'Sort ascending',
      name: 'sortAscending',
      desc: '',
      args: [],
    );
  }

  /// `Sort descending`
  String get sortDescending {
    return Intl.message(
      'Sort descending',
      name: 'sortDescending',
      desc: '',
      args: [],
    );
  }

  /// `Special edition:`
  String get specialEdition {
    return Intl.message(
      'Special edition:',
      name: 'specialEdition',
      desc: '',
      args: [],
    );
  }

  /// `Back to the shop`
  String get startExploring {
    return Intl.message(
      'Back to the shop',
      name: 'startExploring',
      desc: '',
      args: [],
    );
  }

  /// `Start searching`
  String get startSearching {
    return Intl.message(
      'Start searching',
      name: 'startSearching',
      desc: '',
      args: [],
    );
  }

  /// `Back to the shop`
  String get start_shopping {
    return Intl.message(
      'Back to the shop',
      name: 'start_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Back to the shop`
  String get startShopping {
    return Intl.message(
      'Back to the shop',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get street {
    return Intl.message(
      'Street',
      name: 'street',
      desc: '',
      args: [],
    );
  }

  /// `Street is required`
  String get streetIsRequired {
    return Intl.message(
      'Street is required',
      name: 'streetIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Street Number`
  String get streetNumber {
    return Intl.message(
      'Street Number',
      name: 'streetNumber',
      desc: '',
      args: [],
    );
  }

  /// `Street number is required`
  String get streetNumberIsRequired {
    return Intl.message(
      'Street number is required',
      name: 'streetNumberIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message(
      'Subtotal',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Your order completed successfully.`
  String get orderCompletedAndPaid {
    return Intl.message(
      'Your order completed successfully.',
      name: 'orderCompletedAndPaid',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately, your payment could not be processed successfully.`
  String get orderNotCompletedAndPaid {
    return Intl.message(
      'Unfortunately, your payment could not be processed successfully.',
      name: 'orderNotCompletedAndPaid',
      desc: '',
      args: [],
    );
  }

  /// `Paid with Google Pay`
  String get successful_payment_gpay {
    return Intl.message(
      'Paid with Google Pay',
      name: 'successful_payment_gpay',
      desc: '',
      args: [],
    );
  }

  /// `Paid with card`
  String get successful_payment_card {
    return Intl.message(
      'Paid with card',
      name: 'successful_payment_card',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful`
  String get successful_payment {
    return Intl.message(
      'Payment successful',
      name: 'successful_payment',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `TAX (20%)`
  String get tax {
    return Intl.message(
      'TAX (20%)',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your day of birth and you may receive a special gift`
  String get tellUsYourBirthdayToGetASpecialGift {
    return Intl.message(
      'Tell us your day of birth and you may receive a special gift',
      name: 'tellUsYourBirthdayToGetASpecialGift',
      desc: '',
      args: [],
    );
  }

  /// `I declare that I have reached the age of 18 and accept `
  String get termsPopUp {
    return Intl.message(
      'I declare that I have reached the age of 18 and accept ',
      name: 'termsPopUp',
      desc: '',
      args: [],
    );
  }

  /// ` of Bottleroom s.r.o. which includes acceptance that some of your sensitive information such as name, card number, phone number, location, address, installed application information and similar will be shared with Stripe Inc. to provide a secure and reliable payment experience.`
  String get termsPopUpCompany {
    return Intl.message(
      ' of Bottleroom s.r.o. which includes acceptance that some of your sensitive information such as name, card number, phone number, location, address, installed application information and similar will be shared with Stripe Inc. to provide a secure and reliable payment experience.',
      name: 'termsPopUpCompany',
      desc: '',
      args: [],
    );
  }

  /// `General Commercial Terms and Privacy Policy Guidelines`
  String get termsPopUpLink {
    return Intl.message(
      'General Commercial Terms and Privacy Policy Guidelines',
      name: 'termsPopUpLink',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get termsPopUpNo {
    return Intl.message(
      'Reject',
      name: 'termsPopUpNo',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get termsPopUpYes {
    return Intl.message(
      'Accept',
      name: 'termsPopUpYes',
      desc: '',
      args: [],
    );
  }

  /// `Confirm terms`
  String get termsTitleMainScreen {
    return Intl.message(
      'Confirm terms',
      name: 'termsTitleMainScreen',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your order`
  String get thankYouForYourOrder {
    return Intl.message(
      'Thank you for your order',
      name: 'thankYouForYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Quantity of the product/s in the cart exceeds the current stock. Please update the cart accordingly`
  String get theCartContainsItemCountsThatAreNotAvailableIn {
    return Intl.message(
      'Quantity of the product/s in the cart exceeds the current stock. Please update the cart accordingly',
      name: 'theCartContainsItemCountsThatAreNotAvailableIn',
      desc: '',
      args: [],
    );
  }

  /// `To be shipped`
  String get to_be_shipped {
    return Intl.message(
      'To be shipped',
      name: 'to_be_shipped',
      desc: '',
      args: [],
    );
  }

  /// `Total paid`
  String get totalPaid {
    return Intl.message(
      'Total paid',
      name: 'totalPaid',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Tutorial`
  String get tutorial {
    return Intl.message(
      'Tutorial',
      name: 'tutorial',
      desc: '',
      args: [],
    );
  }

  /// `Unable to authenticate. Please try again later`
  String get unableToAuthenticatePleaseTryAgainLater {
    return Intl.message(
      'Unable to authenticate. Please try again later',
      name: 'unableToAuthenticatePleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately the application was unable to start`
  String get unfortunatelyTheApplicationWasUnableToStart {
    return Intl.message(
      'Unfortunately the application was unable to start',
      name: 'unfortunatelyTheApplicationWasUnableToStart',
      desc: '',
      args: [],
    );
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message(
      'Unpaid',
      name: 'unpaid',
      desc: '',
      args: [],
    );
  }

  /// `Ups, something went wrong`
  String get upsSomethingWentWrong {
    return Intl.message(
      'Ups, something went wrong',
      name: 'upsSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Use as shipping address`
  String get useAsShippingAddress {
    return Intl.message(
      'Use as shipping address',
      name: 'useAsShippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `User already signed up with different provider`
  String get userAlreadySignedUpWithDifferentProvider {
    return Intl.message(
      'User already signed up with different provider',
      name: 'userAlreadySignedUpWithDifferentProvider',
      desc: '',
      args: [],
    );
  }

  /// `User with this email already exists`
  String get userWithThisEmailAlreadyExists {
    return Intl.message(
      'User with this email already exists',
      name: 'userWithThisEmailAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `User with this email not found`
  String get userWithThisEmailNotFound {
    return Intl.message(
      'User with this email not found',
      name: 'userWithThisEmailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Value is not a number`
  String get value_not_number {
    return Intl.message(
      'Value is not a number',
      name: 'value_not_number',
      desc: '',
      args: [],
    );
  }

  /// `VAT (20%)`
  String get vat20 {
    return Intl.message(
      'VAT (20%)',
      name: 'vat20',
      desc: '',
      args: [],
    );
  }

  /// `Verify your quantity and click checkout`
  String get verify_quantity {
    return Intl.message(
      'Verify your quantity and click checkout',
      name: 'verify_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Verify your quantity and click checkout`
  String get verifyQuantity {
    return Intl.message(
      'Verify your quantity and click checkout',
      name: 'verifyQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Volume:`
  String get volume {
    return Intl.message(
      'Volume:',
      name: 'volume',
      desc: '',
      args: [],
    );
  }

  /// `Volume (liters)`
  String get volumeLiters {
    return Intl.message(
      'Volume (liters)',
      name: 'volumeLiters',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting {
    return Intl.message(
      'Waiting',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `We're working on it...`
  String get wereWorkingOnIt {
    return Intl.message(
      'We\'re working on it...',
      name: 'wereWorkingOnIt',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get wish_list {
    return Intl.message(
      'Favorites',
      name: 'wish_list',
      desc: '',
      args: [],
    );
  }

  /// `Vintage`
  String get year {
    return Intl.message(
      'Vintage',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Vintage`
  String get years {
    return Intl.message(
      'Vintage',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `You must first agree to Terms & Conditions`
  String get youMustFirstAgreeToTermsConditions {
    return Intl.message(
      'You must first agree to Terms & Conditions',
      name: 'youMustFirstAgreeToTermsConditions',
      desc: '',
      args: [],
    );
  }

  /// `You're using an incompatible version of the app`
  String get youreUsingAnIncompatibleVersionOfTheApp {
    return Intl.message(
      'You\'re using an incompatible version of the app',
      name: 'youreUsingAnIncompatibleVersionOfTheApp',
      desc: '',
      args: [],
    );
  }

  /// `Your Orders`
  String get your_orders {
    return Intl.message(
      'Your Orders',
      name: 'your_orders',
      desc: '',
      args: [],
    );
  }

  /// `yyyy-MM-dd`
  String get yyyymmdd {
    return Intl.message(
      'yyyy-MM-dd',
      name: 'yyyymmdd',
      desc: '',
      args: [],
    );
  }

  /// `ZIP Code`
  String get zipCode {
    return Intl.message(
      'ZIP Code',
      name: 'zipCode',
      desc: '',
      args: [],
    );
  }

  /// `ZIP code is required`
  String get zipCodeIsRequired {
    return Intl.message(
      'ZIP code is required',
      name: 'zipCodeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Email could not be sent`
  String get confirmationEmailNotSent {
    return Intl.message(
      'Email could not be sent',
      name: 'confirmationEmailNotSent',
      desc: '',
      args: [],
    );
  }

  /// `You have an empty cart.`
  String get youHaveAnEmptyCart {
    return Intl.message(
      'You have an empty cart.',
      name: 'youHaveAnEmptyCart',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your age`
  String get ageValidationDialogTitle {
    return Intl.message(
      'Confirm your age',
      name: 'ageValidationDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `You must be at least 18 years old to enter the site`
  String get ageValidationDialogLabel {
    return Intl.message(
      'You must be at least 18 years old to enter the site',
      name: 'ageValidationDialogLabel',
      desc: '',
      args: [],
    );
  }

  /// `I have reached 18 years`
  String get ageValidationDialogButtonYes {
    return Intl.message(
      'I have reached 18 years',
      name: 'ageValidationDialogButtonYes',
      desc: '',
      args: [],
    );
  }

  /// `I have not reached 18 years`
  String get ageValidationDialogButtonNo {
    return Intl.message(
      'I have not reached 18 years',
      name: 'ageValidationDialogButtonNo',
      desc: '',
      args: [],
    );
  }

  /// `You need to login first`
  String get youNeedToLoginFirst {
    return Intl.message(
      'You need to login first',
      name: 'youNeedToLoginFirst',
      desc: '',
      args: [],
    );
  }

  /// `To order a selected item, you need to log-in first`
  String get loginNeededForPurchase {
    return Intl.message(
      'To order a selected item, you need to log-in first',
      name: 'loginNeededForPurchase',
      desc: '',
      args: [],
    );
  }

  /// `To favorite the selected item, you need to log-in first`
  String get loginNeededForFavorite {
    return Intl.message(
      'To favorite the selected item, you need to log-in first',
      name: 'loginNeededForFavorite',
      desc: '',
      args: [],
    );
  }

  /// `No such product`
  String get noSuchProduct {
    return Intl.message(
      'No such product',
      name: 'noSuchProduct',
      desc: '',
      args: [],
    );
  }

  /// `No such category`
  String get noSuchCategory {
    return Intl.message(
      'No such category',
      name: 'noSuchCategory',
      desc: '',
      args: [],
    );
  }

  /// `Checkout failure`
  String get checkoutFailure {
    return Intl.message(
      'Checkout failure',
      name: 'checkoutFailure',
      desc: '',
      args: [],
    );
  }

  /// `Checkout success`
  String get checkoutSuccess {
    return Intl.message(
      'Checkout success',
      name: 'checkoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Promo code removed`
  String get promoCodeRemoved {
    return Intl.message(
      'Promo code removed',
      name: 'promoCodeRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get menuTerms {
    return Intl.message(
      'Terms & Conditions',
      name: 'menuTerms',
      desc: '',
      args: [],
    );
  }

  /// `Back to orders`
  String get backToOrders {
    return Intl.message(
      'Back to orders',
      name: 'backToOrders',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message(
      'Sale',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Delivery within 1-2 days. Shipping fee 5€`
  String get deliveryWithin12DaysShippingFee5 {
    return Intl.message(
      'Delivery within 1-2 days. Shipping fee 5€',
      name: 'deliveryWithin12DaysShippingFee5',
      desc: '',
      args: [],
    );
  }

  /// `Cash on delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Pay upfront`
  String get payUpfront {
    return Intl.message(
      'Pay upfront',
      name: 'payUpfront',
      desc: '',
      args: [],
    );
  }

  /// `Pay later`
  String get payLater {
    return Intl.message(
      'Pay later',
      name: 'payLater',
      desc: '',
      args: [],
    );
  }

  /// `Wholesale`
  String get wholesale {
    return Intl.message(
      'Wholesale',
      name: 'wholesale',
      desc: '',
      args: [],
    );
  }

  /// `You can buy alcohol from us at wholesale prices, if you hold a license to sell or distribute alcohol.\n\nIf you are interested, contact us by email at info@bottleshop3veze.sk.`
  String get wholesaleDescription {
    return Intl.message(
      'You can buy alcohol from us at wholesale prices, if you hold a license to sell or distribute alcohol.\n\nIf you are interested, contact us by email at info@bottleshop3veze.sk.',
      name: 'wholesaleDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteAccount {
    return Intl.message(
      'Delete',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountDialogTitle {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `All your account data will be erased and will no longer be recoverable`
  String get deleteAccountDialogLabel {
    return Intl.message(
      'All your account data will be erased and will no longer be recoverable',
      name: 'deleteAccountDialogLabel',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get deleteAccountNegativeOption {
    return Intl.message(
      'Close',
      name: 'deleteAccountNegativeOption',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'sk', countryCode: 'SK'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
