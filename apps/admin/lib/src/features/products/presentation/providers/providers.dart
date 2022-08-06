import 'package:bottleshop_admin/src/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/data/repositories/products_repository.dart';
import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_view_model.dart';
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
  (ref) => PagedProductsViewModel<DocumentSnapshot>(
    (lastDoc) => ref
        .watch(productsRepositoryProvider)
        .getAllPagedProductsStream(lastDoc),
  )..requestData(),
);
