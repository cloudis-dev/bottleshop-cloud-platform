import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUsersListProvider = FutureProvider(
  (ref) => FirebaseFirestore.instance
      .collection('users')
      .where('email', isNull: false)
      .get(),
);
