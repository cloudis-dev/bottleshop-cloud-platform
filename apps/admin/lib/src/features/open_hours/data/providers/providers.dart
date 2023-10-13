import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/utils/sorting_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

import 'package:bottleshop_admin/src/features/open_hours/data/models/open_hours_model.dart';

class OpenHoursStateNotifier
    extends SingleStreamItemsStateNotifier<OpenHourModel, String?> {
  OpenHoursStateNotifier(
    Stream<ItemsStateStreamBatch<OpenHourModel>> Function() requestStream,
  ) : super(
          requestStream,
          PromoCodeItemsHandler(),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class PromoCodeItemsHandler extends ItemsHandler<OpenHourModel, String?> {
  PromoCodeItemsHandler()
      : super(
          (a, b) => SortingUtil.stringSortCompare(a.dateFrom.toString(), b.dateFrom.toString()),
          (a) => a.hashCode.toString(),
        );
}

//final openHoursStreamProvider = FutureProvider((ref) => openHoursDb.streamQueryListWithChangesAll()));
   
final openHoursStreamProvider = StreamProvider<List<OpenHourModel>>((ref) {
  final openHours = FirebaseFirestore.instance.collection(Constants.openHoursCollection);
  return openHours.snapshots().asyncMap((querySnapshot) async {
    final data = querySnapshot.docs;
    final openHours = <OpenHourModel>[];

    for (var doc in data) {
      final docData = doc.data();
      final openHour = OpenHourModel.fromMap(docData);
      openHours.add(openHour);
    }

    return openHours;
  });
});