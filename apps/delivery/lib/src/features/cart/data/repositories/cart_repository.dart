import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/cart/data/services/cart_content_service.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CartRepository).toString());

class CartRepository {
  final CloudFunctionsService cloudFunctionsService;

  final CartContentService cartContentService;
  final DatabaseService<CartModel> cartService;
  final DatabaseService<ProductModel> productsService;

  CartRepository({
    required this.cartService,
    required this.cartContentService,
    required this.productsService,
    required this.cloudFunctionsService,
  });

  Stream<bool> isInCartStream(String id) {
    return cartContentService.streamSingle(id).map((event) => event != null);
  }

  Future<bool> promoApplied(String promo) {
    return cloudFunctionsService.addPromoCode(promo);
  }

  Future<bool> promoRemoved() {
    return cloudFunctionsService.removePromoCode();
  }

  Future<bool> isCartContentsAvailableInStock() async {
    final cartItems = await cartContentService.getCartItems();
    return Future.wait(
      cartItems.map(
        (element) => productsService.getSingle(element.product.uniqueId).then(
              (value) => value == null ? false : value.count >= element.count,
            ),
      ),
    ).then(
      (value) => value.every((hasEnoughInStock) => hasEnoughInStock),
    );
  }

  Future<void> add(String id, int quantity) async {
    _logger.fine('adding id $id QTY: $quantity');
    final ref = cartService.db
        .collection(FirestoreCollections.productsCollection)
        .doc(id);
    final cartItem = await cartContentService.getSingle(id);
    if (cartItem == null) {
      final record = CartRecord(productRef: ref, quantity: quantity);
      await cartContentService.create(record.toMap(), id: id);
    } else {
      await cartContentService.updateData(
        id,
        cartItem.copyWith(quantity: cartItem.quantity + quantity).toMap(),
      );
    }
  }

  Future<void> removeItem(String id) async {
    _logger.fine('removing $id');
    return cartContentService.removeItem(id);
  }

  Stream<int> getQuantityOfCartItemStream(String id) {
    return cartContentService
        .streamSingle(id)
        .map((value) => value?.quantity ?? 0);
  }

  Future<void> setItemQty(String id, int newQty) async {
    if (newQty < 1) {
      return removeItem(id);
    }

    final record = CartRecord(
      productRef: cartContentService.db
          .collection(FirestoreCollections.productsCollection)
          .doc(id),
      quantity: newQty,
    );

    return cartContentService.updateData(id, record.toMap());
  }

  Stream<List<CartItemModel>> get cartContent =>
      cartContentService.getCartItemsStream();

  Stream<CartModel> get cart => cartService
      .streamSingle(FirestoreCollections.userCartId)
      .map((event) => event ?? const CartModel.empty());

  Future<CartModel?> getCartModel() {
    return cartService.getSingle(FirestoreCollections.userCartId);
  }
}
