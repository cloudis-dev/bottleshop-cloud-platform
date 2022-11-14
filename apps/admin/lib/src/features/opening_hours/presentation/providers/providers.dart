import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final openingHoursProvider = StreamProvider((ref) =>
    FirebaseFirestore.instance.collection('opening_hours').snapshots());

final editHoursProvider =
    StateProvider<Map<String, OpeningHoursModel>?>((ref) => null);

final sortedWeekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
