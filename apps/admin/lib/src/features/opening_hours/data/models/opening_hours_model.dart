import 'package:cloud_firestore/cloud_firestore.dart';

class OpeningHoursModel {
  final String opening;
  final String closing;

  OpeningHoursModel({
    required this.opening,
    required this.closing,
  });

  static Map<String, OpeningHoursModel> fromMap(
      QuerySnapshot<Map<String, dynamic>> map) {
    late Map<String, OpeningHoursModel> tempMap;
    for (var element in map.docs) {
      tempMap = element.data().map(
            (key, value) => MapEntry(
              key,
              OpeningHoursModel(opening: value[0], closing: value[1]),
            ),
          );
    }
    return tempMap;
  }

  static Map<String, dynamic> toMap(Map<String, OpeningHoursModel> map) {
    final newMap = map.map((key, value) => MapEntry(
          key,
          [value.opening, value.closing],
        ));
    return newMap;
  }

  static bool isOpened(String opening, String closing) {
    var isOpened = true;
    if (opening == '0' || closing == '0') {
      isOpened = false;
    }
    return isOpened;
  }
}
