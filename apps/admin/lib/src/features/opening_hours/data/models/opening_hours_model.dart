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
      monday: OpeningHoursEntryModel.fromMap(map['Monday']),
      tuesday: OpeningHoursEntryModel.fromMap(map['Tuesday']),
      wednesday: OpeningHoursEntryModel.fromMap(map['Wednesday']),
      thursday: OpeningHoursEntryModel.fromMap(map['Thursday']),
      friday: OpeningHoursEntryModel.fromMap(map['Friday']),
      saturday: OpeningHoursEntryModel.fromMap(map['Saturday']),
      sunday: OpeningHoursEntryModel.fromMap(map['Sunday']),
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
