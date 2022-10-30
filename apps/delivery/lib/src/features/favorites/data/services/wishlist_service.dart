import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/auth/data/services/user_db_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/data/models/favorite_item_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((WishListService).toString());

class WishListService {
  final Ref ref;
  late WishListDBService? db;

  WishListService(this.ref) {
    final uid = ref.read(currentUserProvider)?.uid;
    db = uid == null
        ? null
        : WishListDBService(FirestorePaths.userFavorites(uid));
  }

  Future<void> add(String? id) async {
    if (db == null) return;

    _logger.info('adding $id');
    var ref =
        db!.db.collection(FirestoreCollections.productsCollection).doc(id);
    var item = FavoriteItemModel(product: ref, addedAt: DateTime.now());
    await db!.create(item.toMap(), id: id);
  }

  Future<void> remove(String id) async {
    if (db == null) return;

    _logger.info('removing $id');
    await db!.removeItem(id);
  }

  Stream<List<ProductModel>> get wishList =>
      db == null ? const Stream.empty() : db!.getWishListStream();
}
