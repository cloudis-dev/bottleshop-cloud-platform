import 'package:bottleshop_admin/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class FlashSalesPaginationStateNotifier
    extends SingleStreamItemsStateNotifier<FlashSaleModel, String?> {
  FlashSalesPaginationStateNotifier(
    Stream<ItemsStateStreamBatch<FlashSaleModel>> Function() createStream,
  ) : super(
          createStream,
          FlashSalesHandler(),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class FlashSalesHandler extends ItemsHandler<FlashSaleModel, String?> {
  FlashSalesHandler()
      : super(
          // The closer to present is the first
          (a, b) => b.flashSaleUntil.compareTo(a.flashSaleUntil),
          (a) => a.uniqueId,
        );
}
