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

import 'package:delivery/src/core/data/models/localized_model.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

@immutable
class OpenHourModel {
  final int _hourFrom;
  final int _hourTo;
  final DateTime _dateFrom;
  final DateTime _dateTo;

  const OpenHourModel({
  required int hourFrom,
  required int hourTo,
  required DateTime dateFrom,
  required DateTime dateTo,
  })  : _hourFrom = hourFrom,
        _hourTo = hourTo,
        _dateFrom = dateFrom,
        _dateTo = dateTo;

  factory OpenHourModel.fromMap(Map<String, dynamic> data) {
    return OpenHourModel(
      hourTo: data['hourTo'],
      hourFrom: data['hourFrom'],
      dateFrom: data['dateFrom'].toDate(),
      dateTo:data['dateTo'].toDate()
    );
  }

  int get hourTo => _hourTo;
  int get hourFrom => _hourFrom;
  DateTime get DateTo => _dateTo;
  DateTime get DateFrom => _dateFrom;
}

