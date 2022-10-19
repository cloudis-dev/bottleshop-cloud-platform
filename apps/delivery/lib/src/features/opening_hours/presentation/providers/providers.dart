import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

final openingHoursProvider = StreamProvider((ref) =>
    FirebaseFirestore.instance.collection('opening_hours').snapshots());

final editHoursProvider =
    StateProvider<Map<String, OpeningHours>?>((ref) => null);

final sortedWeekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
