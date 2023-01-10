import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';

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

  static OpeningHoursModel fromMap(Map<String, dynamic> map) {
    return OpeningHoursModel(
      monday: OpeningHoursEntryModel(
          closing: map['Monday']![1], opening: map['Monday']![0]),
      tuesday: OpeningHoursEntryModel(
          closing: map['Tuesday']![1], opening: map['Tuesday']![0]),
      wednesday: OpeningHoursEntryModel(
          closing: map['Wednesday']![1], opening: map['Wednesday']![0]),
      thursday: OpeningHoursEntryModel(
          closing: map['Thursday']![1], opening: map['Thursday']![0]),
      friday: OpeningHoursEntryModel(
          closing: map['Friday']![1], opening: map['Friday']![0]),
      saturday: OpeningHoursEntryModel(
          closing: map['Saturday']![1], opening: map['Saturday']![0]),
      sunday: OpeningHoursEntryModel(
          closing: map['Sunday']![1], opening: map['Sunday']![0]),
    );
  }

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
    return throw Exception();
  }

  static bool isOpened(OpeningHoursEntryModel? today) {
    var weAreOpen = false;
    if (today?.opening != '0' || today?.closing != '0') {
      weAreOpen = true;
    }
    return weAreOpen;
  }

  OpeningHoursModel setDay(int rowIndex, OpeningHoursEntryModel value) {
    switch (rowIndex) {
      case 0:
        return copyWith(monday: value);
      case 1:
        return copyWith(tuesday: value);
      case 2:
        return copyWith(wednesday: value);
      case 3:
        return copyWith(thursday: value);
      case 4:
        return copyWith(friday: value);
      case 5:
        return copyWith(saturday: value);
      case 6:
        return copyWith(sunday: value);
    }
    throw Exception('No such day for index');
  }

  OpeningHoursModel copyWith({
    OpeningHoursEntryModel? monday,
    OpeningHoursEntryModel? tuesday,
    OpeningHoursEntryModel? wednesday,
    OpeningHoursEntryModel? thursday,
    OpeningHoursEntryModel? friday,
    OpeningHoursEntryModel? saturday,
    OpeningHoursEntryModel? sunday,
  }) {
    return OpeningHoursModel(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }
}
