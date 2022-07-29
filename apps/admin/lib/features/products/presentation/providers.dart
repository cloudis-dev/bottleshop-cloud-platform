import 'package:bottleshop_admin/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/core/pagination_toolbox/products/products_pagination_state_notifier.dart';
import 'package:bottleshop_admin/features/products/data/products_repository.dart';
import 'package:bottleshop_admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsRepositoryProvider = Provider((_) => ProductsRepository());

final productThumbnailImgProvider =
    FutureProvider.autoDispose.family<String, ProductModel>(
  (_, product) => FirebaseStorageService.getDownloadUrlFromPath(
    product.thumbnailPath!,
  ),
);

final productsStateProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PagedProductsStateNotifier<DocumentSnapshot>(
    (lastDoc) => ref
        .watch(productsRepositoryProvider)
        .getAllPagedProductsStream(lastDoc),
  )..requestData(),
);
