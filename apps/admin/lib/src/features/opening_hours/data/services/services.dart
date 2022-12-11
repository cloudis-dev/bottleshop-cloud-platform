import 'package:cloud_firestore/cloud_firestore.dart';

const collection = 'opening_hours';
const doc = 'USFRRzUNHuYt4mwmjsAM';

final openingHoursDoc =
    FirebaseFirestore.instance.collection(collection).doc(doc);

final openingHoursSnapshot =
    FirebaseFirestore.instance.collection(collection).snapshots();
