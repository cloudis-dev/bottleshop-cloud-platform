import 'dart:async';

import 'package:bottleshop_admin/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/features/products/presentation/providers.dart';
import 'package:bottleshop_admin/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:bottleshop_admin/features/section_flash_sales/data/services/services.dart';
import 'package:bottleshop_admin/features/section_flash_sales/presentation/providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class FlashSalesRepository {
  final ProviderReference _providerRef;

  FlashSalesRepository(this._providerRef);

  DocumentReference getDocRef(FlashSaleModel flashSale) {
    return FirebaseFirestore.instance
        .collection(flashSalesDbService.collection)
        .doc(flashSale.uniqueId);
  }

  Stream<FlashSaleModel> getFlashSaleStream() {
    return flashSalesDbService
        .streamQueryListWithChanges(limit: 1)
        .map((event) => event.first.item3);
  }

  /// Currently it is only returning a single flashSale
  /// TODO: this will be returning list of flashSaleModels - postMVP
  Stream<ItemsStateStreamBatch<FlashSaleModel>> allFlashSalesStream() {
    return flashSalesDbService.streamQueryListWithChangesAll().map(
          (event) => ItemsStateStreamBatch<FlashSaleModel>(
            event
                .map((e) => Tuple2(
                    ChangeStatusUtil.convertFromFirestoreChange(e.item1),
                    e.item2))
                .toList(),
          ),
        );
  }

  Future<void> updateFlashSale(FlashSaleModel updatedFlashSale) async {
    final products = await _providerRef
        .read(flashSaleProductsRepository)
        .getFlashSaleProducts(updatedFlashSale.uniqueId);
    final batch = FirebaseFirestore.instance.batch();

    for (var element in products) {
      batch.update(
        _providerRef.read(productsRepositoryProvider).getDocRef(element),
        element.copyWith(flashSale: updatedFlashSale).toFirebaseJson(),
      );
    }

    batch.update(
        getDocRef(updatedFlashSale), updatedFlashSale.toFirebaseJson());

    return batch.commit();
  }
}
