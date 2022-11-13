import 'package:cloud_firestore/cloud_firestore.dart';

class OpeningHoursModel {
  final String opening;
  final String closing;

  OpeningHoursModel({
    required this.opening,
    required this.closing,
  });

  static Map<String, OpeningHoursModel> fromMap(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    late final Map<String, OpeningHoursModel> tempMap;
    for (var element in docs) {
      tempMap = element.data().map(
            (key, value) => MapEntry(
              key,
              OpeningHoursModel(opening: value[0], closing: value[1]),
            ),
          );
    }
    return tempMap;
  }
}
