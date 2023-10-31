
import 'package:flutter/material.dart';

@immutable
class OpenHourModel {
  final DateTime _dateFrom;
  final DateTime _dateTo;
  final String _type;
  final String _message;
  final bool _isClosed;

  const OpenHourModel({
  required DateTime dateFrom,
  required DateTime dateTo,
  required String type,
  required String message,
  required bool isClosed
  })  : _dateFrom = dateFrom,
        _dateTo = dateTo,
        _type = type,
        _isClosed = isClosed,
        _message = message;

  factory OpenHourModel.fromMap(Map<String, dynamic> data) {
    return OpenHourModel(
      dateFrom: data['dateFrom'].toDate(),
      dateTo:data['dateTo'].toDate(),
      type: data['type'],
      isClosed : data['isClosed'],
      message: data['message']
    );
  }

  DateTime get dateTo => _dateTo;
  DateTime get dateFrom => _dateFrom;
  String get type => _type;
  bool get isClosed => _isClosed;
  String get message => _message;

    OpenHourModel updateDateTimes(DateTime dateFrom, DateTime dateTo) {
    return OpenHourModel(
      dateFrom: dateFrom,
      dateTo: dateTo,
      type: _type,
      isClosed: _isClosed,
      message: message
    );
  }

}

