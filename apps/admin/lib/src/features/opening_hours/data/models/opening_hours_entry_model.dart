class OpeningHoursEntryModel {
  final String opening;
  final String closing;

  OpeningHoursEntryModel({
    required String opening,
    required String closing,
  })  : opening = amendMidnight(opening),
        closing = amendMidnight(closing);

  static String amendMidnight(String time) {
    if (time == '00:00') {
      return '24:00';
    }
    return time;
  }

  OpeningHoursEntryModel.closed()
      : opening = '0',
        closing = '0';

  OpeningHoursEntryModel.opened()
      : opening = '88:88',
        closing = '88:88';

  static OpeningHoursEntryModel fromMap(List<dynamic> map) =>
      OpeningHoursEntryModel(opening: map[0], closing: map[1]);

  static Map<String, dynamic> toMap(Map<String, OpeningHoursEntryModel> map) {
    final newMap = map.map((key, value) => MapEntry(
          key,
          [value.opening, value.closing],
        ));
    return newMap;
  }

  bool isOpened() {
    return opening != '0' || closing != '0';
  }

  OpeningHoursEntryModel copyWith({
    String? opening,
    String? closing,
  }) {
    return OpeningHoursEntryModel(
      opening: opening ?? this.opening,
      closing: closing ?? this.closing,
    );
  }
}
