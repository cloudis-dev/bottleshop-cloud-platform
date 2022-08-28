import 'dart:async';

import 'package:delivery/src/features/product_sections/presentation/view_models/flash_sale_products_state_notifier.dart';
import 'package:delivery/src/features/products/data/models/flash_sale_model.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/view_models/products_state_notifier.dart';
import 'package:delivery/src/features/sorting/data/models/sort_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final newArrivalsProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      ref.watch(productsRepositoryProvider).getNewProductsStream,
      const SortModel(sortField: SortField.name, ascending: true),
    )..requestData();
  },
);

final saleProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      ref.watch(productsRepositoryProvider).getSaleProductsStream,
      const SortModel(sortField: SortField.name, ascending: true),
    )..requestData();
  },
);

final recommendedProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      ref.watch(productsRepositoryProvider).getRecommendedProductsStream,
      const SortModel(sortField: SortField.name, ascending: true),
    )..requestData();
  },
);

final flashSaleProductsProvider =
    ChangeNotifierProvider.autoDispose<FlashSaleProductsStateNotifier>(
  (ref) {
    return FlashSaleProductsStateNotifier(
      ref.watch(productsRepositoryProvider).getFlashSaleProductsStream,
    )..requestData();
  },
);

final _logger = Logger((flashSaleEndProvider).toString());

/// This is using FlashSaleModel as family, so products with the same flash sale
/// will have the same provider.
final flashSaleEndProvider =
    StreamProvider.autoDispose.family<Duration, FlashSaleModel>(
  (ref, flashSale) {
    final streamController = StreamController<Duration>();
    Timer? timer;

    _logger.fine('flashSale resolved ${flashSale.flashSaleUntil.toString()}');
    var durationTillEnd = flashSale.flashSaleUntil.difference(DateTime.now());
    streamController.add(durationTillEnd);
    _logger.fine('streamed durationUntilEnd: ${durationTillEnd.inHours}');
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      var durationTillEnd = flashSale.flashSaleUntil.difference(DateTime.now());
      streamController.add(durationTillEnd);
      _logger.fine('streamed durationUntilEnd: ${durationTillEnd.inHours}');
    });

    ref.onDispose(() {
      streamController.close();
      timer?.cancel();
      _logger.fine(
          'disposed stream closed: ${streamController.isClosed} timer cancelled: ${!(timer?.isActive ?? false)}');
    });

    final resultStream = streamController.stream.asBroadcastStream()
      ..listen(
        (event) =>
            // When ticked, check the flash sales if all the products are in time.
            ref.read(flashSaleProductsProvider).checkFlashSaleItemsTime(),
      );

    return resultStream;
  },
);
