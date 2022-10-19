import 'package:cloud_firestore/cloud_firestore.dart';

class OpeningHours {
  final String opening;
  final String closing;

  OpeningHours({
    required this.opening,
    required this.closing,
  });

  static Map<String, OpeningHours> fromMap(
      QuerySnapshot<Map<String, dynamic>> map) {
    late Map<String, OpeningHours> tempMap;
    for (var element in map.docs) {
      tempMap = element.data().map(
            (key, value) => MapEntry(
              key,
              OpeningHours(opening: value[0], closing: value[1]),
            ),
          );
    }
    return tempMap;
  }

  static Map<String, dynamic> toMap(Map<String, OpeningHours> map) {
    final newMap = map.map((key, value) => MapEntry(
          key,
          [value.opening, value.closing],
        ));
    return newMap;
  }
}
