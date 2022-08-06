import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class ChangeStatusUtil {
  ChangeStatusUtil._();

  static ChangeStatus convertFromFirestoreChange(DocumentChangeType change) {
    switch (change) {
      case DocumentChangeType.added:
        return ChangeStatus.added;
      case DocumentChangeType.modified:
        return ChangeStatus.modified;
      case DocumentChangeType.removed:
        return ChangeStatus.removed;
    }
  }
}
