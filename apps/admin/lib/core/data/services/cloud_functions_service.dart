import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

class CloudFunctionsService {
  final FirebaseFunctions _cloudFunctions = FirebaseFunctions.instanceFor(
      app: Firebase.app(), region: 'europe-west1');

  Future<Timestamp> getServerTimestamp() {
    return _cloudFunctions.httpsCallable('getCurrentTimestamp').call().then(
          (value) => Timestamp.fromMillisecondsSinceEpoch(
            value.data['_seconds'] * 1000,
          ),
        );
  }
}
