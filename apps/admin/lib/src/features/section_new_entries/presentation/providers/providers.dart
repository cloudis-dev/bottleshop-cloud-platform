import 'package:bottleshop_admin/src/core/pagination_toolbox/products/products_pagination_state_notifier.dart';
import 'package:bottleshop_admin/src/features/section_new_entries/data/repositories/new_entry_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final newEntryProductsRepositoryProvider =
    Provider((_) => NewEntryProductsRepository());

final newEntryProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      () => ref
          .read(newEntryProductsRepositoryProvider)
          .getNewEntriesProductsStream(),
    )..requestData();
  },
);
