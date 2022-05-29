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

import 'package:delivery/src/features/auth/data/models/address_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:delivery/l10n/l10n.dart';

@immutable
class UserModel extends Equatable {
  final String uid;
  final String? name;
  final String? email;
  final String? avatar;
  final DateTime? dayOfBirth;
  final DateTime? lastLoggedIn;
  final DateTime? registrationDate;
  final bool introSeen;
  final String? phoneNumber;
  final Address? shippingAddress;
  final Address? billingAddress;
  final String? stripeCustomerId;
  final bool isAnonymous;
  final bool isEmailVerified;
  final String? preferredLanguage;

  const UserModel._({
    required this.uid,
    this.isAnonymous = false,
    this.name,
    this.email,
    this.avatar,
    this.dayOfBirth,
    this.lastLoggedIn,
    this.registrationDate,
    this.introSeen = false,
    this.shippingAddress,
    this.billingAddress,
    this.stripeCustomerId,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.preferredLanguage,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel._(
      uid: id,
      name: map[UserFields.name] as String?,
      email: map[UserFields.email] as String?,
      avatar: map[UserFields.avatar] as String?,
      dayOfBirth: map[UserFields.dayOfBirth]?.toDate() as DateTime?,
      lastLoggedIn: map[UserFields.lastLoggedIn]?.toDate() as DateTime?,
      registrationDate: map[UserFields.registrationDate]?.toDate() as DateTime?,
      introSeen: map[UserFields.introSeen] as bool? ?? false,
      phoneNumber: map[UserFields.phoneNumber] as String?,
      shippingAddress:
          map[UserFields.shippingAddress] != null ? Address.fromMap(map[UserFields.shippingAddress]) : null,
      billingAddress: map[UserFields.billingAddress] != null ? Address.fromMap(map[UserFields.billingAddress]) : null,
      stripeCustomerId: map[UserFields.stripeCustomerId] as String?,
      isAnonymous: map[UserFields.anonymousUser] as bool? ?? false,
      isEmailVerified: map[UserFields.isEmailVerified] as bool? ?? false,
      preferredLanguage: map[UserFields.preferredLanguage] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      UserFields.uid: uid,
      UserFields.name: name,
      UserFields.email: email,
      UserFields.avatar: avatar,
      UserFields.dayOfBirth: dayOfBirth,
      UserFields.lastLoggedIn: lastLoggedIn,
      UserFields.registrationDate: registrationDate,
      UserFields.introSeen: introSeen,
      UserFields.phoneNumber: phoneNumber,
      UserFields.shippingAddress: shippingAddress?.toMap(),
      UserFields.billingAddress: billingAddress?.toMap(),
      UserFields.stripeCustomerId: stripeCustomerId,
      UserFields.anonymousUser: isAnonymous,
      UserFields.isEmailVerified: isEmailVerified,
      UserFields.preferredLanguage: preferredLanguage,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatar,
    DateTime? dayOfBirth,
    DateTime? lastLoggedIn,
    DateTime? registrationDate,
    bool? introSeen,
    String? phoneNumber,
    Address? shippingAddress,
    Address? billingAddress,
    String? stripeCustomerId,
    bool? isAnonymous,
    bool? isEmailVerified,
    String? preferredLanguage,
  }) {
    if ((uid == null || identical(uid, this.uid)) &&
        (name == null || identical(name, this.name)) &&
        (email == null || identical(email, this.email)) &&
        (avatar == null || identical(avatar, this.avatar)) &&
        (dayOfBirth == null || identical(dayOfBirth, this.dayOfBirth)) &&
        (lastLoggedIn == null || identical(lastLoggedIn, this.lastLoggedIn)) &&
        (registrationDate == null || identical(registrationDate, this.registrationDate)) &&
        (introSeen == null || identical(introSeen, this.introSeen)) &&
        (phoneNumber == null || identical(phoneNumber, this.phoneNumber)) &&
        (shippingAddress == null || identical(shippingAddress, this.shippingAddress)) &&
        (billingAddress == null || identical(billingAddress, this.billingAddress)) &&
        (stripeCustomerId == null || identical(stripeCustomerId, this.stripeCustomerId)) &&
        (isAnonymous == null || identical(isAnonymous, this.isAnonymous)) &&
        (isEmailVerified == null || identical(isEmailVerified, this.isEmailVerified)) &&
        (preferredLanguage == null || identical(preferredLanguage, this.preferredLanguage))) {
      return this;
    }

    return UserModel._(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      dayOfBirth: dayOfBirth ?? this.dayOfBirth,
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      registrationDate: registrationDate ?? this.registrationDate,
      introSeen: introSeen ?? this.introSeen,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }

  static UserModel? fromFirebaseUser({
    User? user,
    AdditionalUserInfo? additionalData,
  }) {
    if (user == null) {
      return null;
    }
    String? email;
    if (additionalData != null) {
      if (user.email == null && additionalData.profile!['email'] != null) {
        email = additionalData.profile!['email'];
      } else {
        email = user.email;
      }
    } else {
      email = user.email;
    }
    var isFb = user.providerData.where((element) => element.providerId == 'facebook.com').isNotEmpty;

    return UserModel._(
      uid: user.uid,
      email: email,
      name: user.displayName,
      avatar: user.photoURL,
      registrationDate: DateTime.now().toUtc(),
      lastLoggedIn: DateTime.now().toUtc(),
      introSeen: false,
      isAnonymous: user.isAnonymous,
      isEmailVerified: isFb ? true : user.emailVerified,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        isAnonymous,
        name,
        email,
        avatar,
        dayOfBirth,
        lastLoggedIn,
        registrationDate,
        introSeen,
        shippingAddress,
        billingAddress,
        stripeCustomerId,
        phoneNumber,
        isEmailVerified,
        preferredLanguage,
      ];

  @override
  bool get stringify => true;
}

class UserFields {
  static const String uid = 'uid';
  static const String name = 'name';
  static const String email = 'email';
  static const String avatar = 'avatar';
  static const String introSeen = 'introSeen';
  static const String dayOfBirth = 'dayOfBirth';
  static const String lastLoggedIn = 'last_logged_in';
  static const String registrationDate = 'registration_date';
  static const String billingAddress = 'billing_address';
  static const String shippingAddress = 'shipping_address';
  static const String stripeCustomerId = 'stripe_customer_id';
  static const String anonymousUser = 'is_anonymous';
  static const String phoneNumber = 'phone_number';
  static const String isEmailVerified = 'email_verified';
  static const String preferredLanguage = 'preferred_language';
}

class StripeCustomer {
  final String? email;
  final StripeMetadata metadata;

  const StripeCustomer({
    required this.metadata,
    this.email,
  });

  factory StripeCustomer.fromUser(UserModel user) {
    return StripeCustomer(metadata: StripeMetadata(uid: user.uid), email: user.email);
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{'metadata': metadata.toMap()};
    if (email != null) {
      data['email'] = email;
    }
    return data;
  }
}

class StripeMetadata {
  final String uid;

  const StripeMetadata({
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': uid,
    } as Map<String, dynamic>;
  }
}
