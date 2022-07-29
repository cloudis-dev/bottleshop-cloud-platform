import 'package:bottleshop_admin/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/features/promo_codes/data/services.dart';
import 'package:bottleshop_admin/models/promo_code_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class PromoCodeAlreadyExistsException implements Exception {
  final String message = 'Promo kód s rovnakým kódom je už vytvorený.';
}

class PromoCodesRepository {
  Future<void> createPromoCode(PromoCodeModel promoCode) async {
    if (await promoCodesDbService.exists(id: promoCode.uid)) {
      throw PromoCodeAlreadyExistsException();
    }

    return promoCodesDbService.create(
      promoCode.toFirebaseJson(),
      id: promoCode.code,
    );
  }

  Future<void> updatePromoCode(
    PromoCodeModel promoCode,
    PromoCodeModel previousCode,
  ) async {
    final batch = FirebaseFirestore.instance.batch();
    await promoCodesDbService.removeItem(previousCode.uid, batch: batch);

    await promoCodesDbService.create(
      promoCode.toFirebaseJson(),
      id: promoCode.uid,
      batch: batch,
    );
    return batch.commit();
  }

  Stream<ItemsStateStreamBatch<PromoCodeModel>> promoCodesStream() {
    return promoCodesDbService.streamQueryListWithChangesAll().map(
          (event) => ItemsStateStreamBatch<PromoCodeModel>(
            event
                .map(
                  (e) => Tuple2(
                    ChangeStatusUtil.convertFromFirestoreChange(e.item1),
                    e.item2,
                  ),
                )
                .toList(),
          ),
        );
  }
}
