import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/favorites/data/services/wishlist_service.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final wishListProvider = Provider.autoDispose<WishListService?>(
  (ref) {
    final uid = ref.watch(currentUserProvider)?.uid;

    return uid == null ? null : WishListService(ref.read);
  },
);

final wishListStreamProvider = StreamProvider.autoDispose<List<ProductModel>?>(
  (ref) => ref.watch(wishListProvider)?.wishList ?? Stream.value(null),
);

final isInWishListStreamProvider = StreamProvider.autoDispose.family<bool?, String>(
  (ref, productId) =>
      ref.watch(wishListProvider)?.wishList.map((event) => event.any((element) => element.uniqueId == productId)) ??
      Stream.value(null),
);
