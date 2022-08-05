import 'package:cloud_firestore/cloud_firestore.dart';

class NoSuchSnapshotExists implements Exception {
  DocumentReference reference;

  NoSuchSnapshotExists(this.reference);

  @override
  String toString() {
    return 'No such snapshot exists: ${reference.path}';
  }
}
