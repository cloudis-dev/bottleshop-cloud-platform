class OpeningHours {
  final String opening;
  final String closing;

  OpeningHours({
    required this.opening,
    required this.closing,
  });

  static Map<String, dynamic> toMap(Map<String, OpeningHours> map) {
    final newMap = map.map((key, value) => MapEntry(
          key,
          [value.opening, value.closing],
        ));
    return newMap;
  }
}
