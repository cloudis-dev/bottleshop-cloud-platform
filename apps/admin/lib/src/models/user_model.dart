import 'package:bottleshop_admin/src/models/address_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserModel extends Equatable {
  final String uid;
  final String? name;
  final String? email;
  final String? avatar;
  final DateTime? dayOfBirth;
  final DateTime? lastLoggedIn;
  final DateTime? registrationDate;
  final bool? introSeen;
  final Address? shippingAddress;
  final Address? billingAddress;
  final String? stripeCustomerId;
  final bool? isAnonymous;
  final String? phoneNumber;

  const UserModel({
    required this.uid,
    this.isAnonymous,
    this.name,
    this.email,
    this.avatar,
    this.dayOfBirth,
    this.lastLoggedIn,
    this.registrationDate,
    this.introSeen,
    this.shippingAddress,
    this.billingAddress,
    this.stripeCustomerId,
    this.phoneNumber,
  });

  UserModel.fromMap(this.uid, Map<String, dynamic> data)
      : name = data[UserFields.name] as String? ?? '',
        email = data[UserFields.email] as String? ?? '',
        avatar = data[UserFields.avatar] as String? ?? '',
        dayOfBirth = data[UserFields.dayOfBirth]?.toDate() as DateTime?,
        lastLoggedIn = data[UserFields.lastLoggedIn]?.toDate() as DateTime?,
        registrationDate =
            data[UserFields.registrationDate]?.toDate() as DateTime?,
        shippingAddress = Address.fromMap(
            data[UserFields.shippingAddress] as Map<String, dynamic>?),
        billingAddress = Address.fromMap(
            data[UserFields.billingAddress] as Map<String, dynamic>?),
        stripeCustomerId = data[UserFields.stripeCustomerId] as String?,
        isAnonymous = data[UserFields.anonymousUserField] as bool? ?? false,
        introSeen = data[UserFields.introSeen] as bool? ?? false,
        phoneNumber = data[UserFields.phoneNumber] as String?;

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data[UserFields.uid] = uid;
    data[UserFields.name] = name;
    data[UserFields.email] = email;
    data[UserFields.avatar] = avatar;
    data[UserFields.dayOfBirth] = dayOfBirth;
    data[UserFields.lastLoggedIn] = lastLoggedIn;
    data[UserFields.registrationDate] = registrationDate;
    data[UserFields.introSeen] = introSeen;
    data[UserFields.anonymousUserField] = isAnonymous;
    data[UserFields.billingAddress] = billingAddress?.toMap();
    data[UserFields.shippingAddress] = shippingAddress?.toMap();
    data[UserFields.stripeCustomerId] = stripeCustomerId;
    data[UserFields.phoneNumber] = phoneNumber;

    return data;
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        avatar,
        dayOfBirth,
        introSeen,
        phoneNumber,
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
  static const String anonymousUserField = 'is_anonymous';
  static const String phoneNumber = 'phone_number';
}
