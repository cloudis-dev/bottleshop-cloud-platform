import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_view_model.dart';
import 'package:bottleshop_admin/src/features/section_new_entries/data/repositories/new_entry_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final newEntryProductsRepositoryProvider =
    Provider((_) => NewEntryProductsRepository());

final newEntryProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductStateViewModel>(
  (ref) {
    return ProductStateViewModel(
      () => ref
          .read(newEntryProductsRepositoryProvider)
          .getNewEntriesProductsStream(),
    )..requestData();
  },
);
