import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/cart/data/repositories/cart_repository.dart';
import 'package:delivery/src/features/cart/data/services/cart_content_service.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_cart_list_item.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cartQuantityStreamProvider =
    StreamProvider.autoDispose.family<int, ProductModel>(
  (ref, product) {
    return ref
        .watch(cartRepositoryProvider)!
        .getQuantityOfCartItemStream(product.uniqueId);
  },
);

/// Returns null in case no user is logged in. So no cart can be fetched.
final isInCartStreamProvider =
    StreamProvider.autoDispose.family<bool?, ProductModel>(
  (ref, product) =>
      ref.watch(cartRepositoryProvider)?.isInCartStream(product.uniqueId) ??
      Stream.value(null),
);


final _cartContentServiceProvider =
    Provider.autoDispose.family<CartContentService, UserModel>(
  (_, user) => CartContentService(user),
);

final orderCartProvider = StateProvider(
  (ref) =>
   'null'
);

final cartRepositoryProvider = Provider.autoDispose<CartRepository?>(
  (ref) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser != null) {
      return CartRepository(
        cloudFunctionsService: ref.watch(cloudFunctionsProvider),
        productsService: ref.watch(productsService),
        cartContentService: ref.watch(_cartContentServiceProvider(currentUser)),
      );
    }

    return null;
  },
);

final cartProvider = StreamProvider.autoDispose<CartModel>(
  (ref) =>
      ref.watch(cartRepositoryProvider)?.streamCart ??
      Stream.value(CartModel.empty()),
);



final isCartEmptyProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(cartProvider).maybeWhen(
        data: (cart) {
          final itemsCount = cart.products.length;
          return itemsCount < 1;
        },
        orElse: () => Future.value(false),
      );
});
