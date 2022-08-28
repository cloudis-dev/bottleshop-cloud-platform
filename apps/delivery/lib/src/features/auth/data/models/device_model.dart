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

@immutable
class Device extends Equatable {
  final String id;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;
  final DeviceDetails? deviceInfo;
  late final String? token;

  Device({
    required this.id,
    this.token,
    this.createdAt,
    this.lastUpdatedAt,
    this.deviceInfo,
  });

  Device.fromMap(this.id, Map<String, dynamic> data)
      : createdAt = data[DeviceFields.createdAt]?.toDate(),
        lastUpdatedAt = data[DeviceFields.lastUpdatedAt]?.toDate(),
        deviceInfo = DeviceDetails.fromJson(data[DeviceFields.deviceInfo]),
        token = data[DeviceFields.token];

  Map<String, dynamic> toMap() {
    return {
      DeviceFields.createdAt: createdAt,
      DeviceFields.deviceInfo: deviceInfo!.toJson(),
      DeviceFields.lastUpdatedAt: lastUpdatedAt,
      DeviceFields.token: token,
    };
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        lastUpdatedAt,
        deviceInfo,
        token,
      ];

  @override
  bool get stringify => true;
}

class DeviceDetails {
  String? device;
  String? model;
  String? osVersion;
  String? platform;

  DeviceDetails({this.device, this.model, this.osVersion, this.platform});

  DeviceDetails.fromJson(Map<String, dynamic> json) {
    device = json[DeviceDetailsFields.device];
    model = json[DeviceDetailsFields.model];
    osVersion = json[DeviceDetailsFields.osVersion];
    platform = json[DeviceDetailsFields.platform];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data[DeviceDetailsFields.device] = device;
    data[DeviceDetailsFields.model] = model;
    data[DeviceDetailsFields.osVersion] = osVersion;
    data[DeviceDetailsFields.platform] = platform;
    return data;
  }
}

class DeviceDetailsFields {
  static const String device = 'device';
  static const String model = 'model';
  static const String osVersion = 'os_version';
  static const String platform = 'platform';
}

class DeviceFields {
  static const String createdAt = 'created_at';
  static const String lastUpdatedAt = 'last_updated_at';
  static const String token = 'token';
  static const String deviceInfo = 'device_info';
}
