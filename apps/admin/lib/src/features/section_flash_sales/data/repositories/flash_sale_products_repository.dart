import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/data/repositories/products_repository.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class NoDiscountOnProductForFlashSaleException implements Exception {
  final String message =
      'Produkt musí mať nastavenú zľavu aby mohol byť pridaný do flash sale.';
}

class FlashSaleProductsRepository {
  Future<void> removeFromFlashSale(
    ProductModel product,
  ) {
    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isFlashSaleField: FieldValue.delete(),
        ProductModel.flashSaleModelField: FieldValue.delete(),
      },
    );
  }

  Future<void> addToFlashSale(
    ProductModel product,
    FlashSaleModel flashSale,
  ) {
    if (!product.hasDiscount) {
      throw NoDiscountOnProductForFlashSaleException();
    }

    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isFlashSaleField: true,
        ProductModel.flashSaleModelField: flashSale.toFirebaseJson(),
      },
    );
  }

  Stream<ItemsStateStreamBatch<ProductModel>> getFlashSaleProductsStream(
    String flashSaleUid,
  ) {
    return productsDbService
        .streamQueryListWithChangesAll(
          args: _flashSaleQueryArgs(flashSaleUid),
          orderBy: ProductsRepository.getProductsOrderBy(),
        )
        .map(
          (event) => ItemsStateStreamBatch<ProductModel>(
            event
                .map(
                  (e) => Tuple2(
                      ChangeStatusUtil.convertFromFirestoreChange(e.item1),
                      e.item2),
                )
                .toList(),
          ),
        );
  }

  Future<List<ProductModel>> getFlashSaleProducts(String? flashSaleUid) {
    return productsDbService.getQueryList(
      args: _flashSaleQueryArgs(flashSaleUid),
      orderBy: ProductsRepository.getProductsOrderBy(),
    );
  }

  List<QueryArgs> _flashSaleQueryArgs(String? flashSaleUid) {
    return [
      QueryArgs(
        '${ProductModel.flashSaleModelField}.${FlashSaleModel.uniqueIdField}',
        isEqualTo: flashSaleUid,
      )
    ];
  }
}
