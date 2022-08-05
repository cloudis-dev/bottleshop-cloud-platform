import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/repositories/promo_codes_repository.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/view_models/promo_codes_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final promoCodesRepository = Provider((_) => PromoCodesRepository());

final initialPromoCodeProvider =
    StateProvider.autoDispose<PromoCodeModel>((_) => PromoCodeModel.empty());

final editedPromoCodeProvider = StateProvider.autoDispose<PromoCodeModel>(
  (ref) => ref.watch(initialPromoCodeProvider).state,
);

final isPromoCodeChangedProvider = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(initialPromoCodeProvider).state !=
      ref.watch(editedPromoCodeProvider).state,
);

final isCreatingPromoCodeProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(initialPromoCodeProvider).state == PromoCodeModel.empty(),
);

final promoCodeFormKeyProvider =
    Provider.autoDispose<GlobalKey<FormState>>((_) => GlobalKey<FormState>());

final promoCodesStreamProvider =
    ChangeNotifierProvider.autoDispose<PromoCodesStateNotifier>(
  (ref) => PromoCodesStateNotifier(
    () => ref.read(promoCodesRepository).promoCodesStream(),
  )..requestData(),
);
