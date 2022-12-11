import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursModel {
  final OpeningHoursEntryModel monday;
  final OpeningHoursEntryModel tuesday;
  final OpeningHoursEntryModel wednesday;
  final OpeningHoursEntryModel thursday;
  final OpeningHoursEntryModel friday;
  final OpeningHoursEntryModel saturday;
  final OpeningHoursEntryModel sunday;

  OpeningHoursModel({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  static OpeningHoursModel fromMap(Map<String, OpeningHoursEntryModel> map) =>
      OpeningHoursModel(
        monday: map['Monday']!,
        tuesday: map['Tuesday']!,
        wednesday: map['Wednesday']!,
        thursday: map['Thursday']!,
        friday: map['Friday']!,
        saturday: map['Saturday']!,
        sunday: map['Sunday']!,
      );

  Map<String, OpeningHoursEntryModel> toMap() => {
        'Monday': monday,
        'Tuesday': tuesday,
        'Wednesday': wednesday,
        'Thursday': thursday,
        'Friday': friday,
        'Saturday': saturday,
        'Sunday': sunday,
      };

  OpeningHoursEntryModel today(int today) {
    switch (today) {
      case 0:
        return monday;
      case 1:
        return tuesday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
    }
    return sunday;
  }

  static bool isOpened(OpeningHoursEntryModel? today) {
    var weAreOpen = false;
    if (today?.opening != '0' || today?.closing != '0') {
      weAreOpen = true;
    }
    return weAreOpen;
  }

  static void newOpeningHours(OpeningHoursModel? openingHours, bool? value,
      BuildContext context, int rowIndex) {
    final newMap = Map.fromEntries(openingHours!.toMap().entries);

    if (value == false) {
      newMap[sortedWeekDays[rowIndex]] =
          OpeningHoursEntryModel(opening: '0', closing: '0');
    } else {
      newMap[sortedWeekDays[rowIndex]] =
          OpeningHoursEntryModel(opening: '88:88', closing: '88:88');
    }
    context.read(editedHoursProvider).state = OpeningHoursModel.fromMap(newMap);
  }
}
