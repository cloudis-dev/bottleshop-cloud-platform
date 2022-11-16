import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/features/opening_hours/data/repositories/opening_hours_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final openingHoursRepProvider = Provider((ref) => OpeningHoursRepository());

final openingHoursProvider = StreamProvider((ref) =>
    FirebaseFirestore.instance.collection('opening_hours').snapshots());

final cartDisclaimerProvider = StateProvider((ref) => false);

final sortedWeekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
