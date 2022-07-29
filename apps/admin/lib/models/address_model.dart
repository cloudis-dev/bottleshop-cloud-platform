import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum AddressType { billing, shipping }

@immutable
class Address extends Equatable {
  final String streetName;
  final String streetNumber;
  final String city;
  final String zipCode;
  final String phoneNumber;

  const Address({
    required this.streetName,
    required this.streetNumber,
    required this.city,
    required this.zipCode,
    required this.phoneNumber,
  });

  static Address? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Address(
      streetName: map['streetName'] as String? ?? '',
      streetNumber: map['streetNumber'] as String? ?? '',
      city: map['city'] as String? ?? '',
      zipCode: map['zipCode'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'streetName': streetName,
      'streetNumber': streetNumber,
      'city': city,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object> get props => [
        streetName,
        streetNumber,
        city,
        zipCode,
        phoneNumber,
      ];

  @override
  bool get stringify => true;

  String getAddressAsString() {
    return '$streetName $streetNumber, $city, $zipCode';
  }
}
