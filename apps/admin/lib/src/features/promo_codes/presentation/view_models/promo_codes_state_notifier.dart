import 'package:bottleshop_admin/src/core/utils/sorting_util.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class PromoCodesStateNotifier
    extends SingleStreamItemsStateNotifier<PromoCodeModel, String?> {
  PromoCodesStateNotifier(
    Stream<ItemsStateStreamBatch<PromoCodeModel>> Function() requestStream,
  ) : super(
          requestStream,
          PromoCodeItemsHandler(),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class PromoCodeItemsHandler extends ItemsHandler<PromoCodeModel, String?> {
  PromoCodeItemsHandler()
      : super(
          (a, b) => SortingUtil.stringSortCompare(a.code, b.code),
          (a) => a.uid,
        );
}
