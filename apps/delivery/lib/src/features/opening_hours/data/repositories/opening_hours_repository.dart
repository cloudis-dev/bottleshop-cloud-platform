import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/features/opening_hours/data/models/opening_hours_model.dart';

class OpeningHoursRepository {
  Future<String> closingHour() async {
    final hours =
        await FirebaseFirestore.instance.collection('opening_hours').get();

    final String todayClosingHour = hours.docs[0][weekday][1];

    return todayClosingHour;
  }
}
