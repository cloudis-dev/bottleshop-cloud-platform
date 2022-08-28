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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum AddressType { billing, shipping }

@immutable
class Address extends Equatable {
  final String streetName;
  final String streetNumber;
  final String city;
  final String zipCode;

  const Address({
    required this.streetName,
    required this.streetNumber,
    required this.city,
    required this.zipCode,
  });

  factory Address.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Address(streetName: '', streetNumber: '', city: '', zipCode: '');
    }
    return Address(
      streetName: map['streetName'] as String? ?? '',
      streetNumber: map['streetNumber'] as String? ?? '',
      city: map['city'] as String? ?? '',
      zipCode: map['zipCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'streetName': streetName,
      'streetNumber': streetNumber,
      'city': city,
      'zipCode': zipCode,
    };
  }

  @override
  List<Object> get props => [
        streetName,
        streetNumber,
        city,
        zipCode,
      ];

  @override
  bool get stringify => true;

  List<String> getAddressPerLines() {
    return [
      '$streetName $streetNumber',
      '$zipCode $city',
    ];
  }

  String getAddressAsString() {
    return '$streetName $streetNumber, $city, $zipCode';
  }
}
