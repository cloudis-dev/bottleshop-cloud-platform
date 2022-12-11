import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/services/services.dart';

final openingHoursProvider = StreamProvider<OpeningHoursModel>((ref) =>
    openingHoursSnapshot.map((event) =>
        OpeningHoursModel.fromMap(OpeningHoursEntryModel.fromMap(event))));

final editedHoursProvider =
    StateProvider.autoDispose<OpeningHoursModel?>((ref) => null);

final sortedWeekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
