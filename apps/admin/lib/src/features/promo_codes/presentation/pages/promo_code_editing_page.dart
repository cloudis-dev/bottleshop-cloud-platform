import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/result_message.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/dialogs/confirm_promo_code_changes_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/dialogs/discard_promo_code_changes_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/min_cart_price_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/promo_code_text_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/promo_discount_percent_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/promo_discount_text_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/usages_count_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _isLoadedProvider = StateProvider.autoDispose<bool>((_) => false);

final _promoCodeTypeProvider =
    StateProvider.autoDispose<PromoCodeType>((_) => PromoCodeType.value);

class PromoCodeEditingPage extends AppPage {
  PromoCodeEditingPage(
    BuildContext context,
    void Function(ResultMessage?) onPopped,
    PromoCodeModel? promoCode,
  ) : super(
          'promo_code/${promoCode == null ? "new" : promoCode.code}',
          (_) => _PromoCodeEditingView(promoCode),
          onPopped: onPopped,
        );

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

class _PromoCodeEditingView extends HookWidget {
  final PromoCodeModel? promoCode;

  const _PromoCodeEditingView(this.promoCode);

  @override
  Widget build(BuildContext context) {
    useProvider(initialPromoCodeProvider);
    useProvider(editedPromoCodeProvider);
    useProvider(promoCodeFormKeyProvider);

    useEffect(
      () {
        Future.microtask(() {
          if (promoCode != null) {
            context.read(initialPromoCodeProvider).state = promoCode!;
          }
          context.read(_isLoadedProvider).state = true;
        });
      },
      [],
    );

    return useProvider(_isLoadedProvider).state
        ? ScaffoldMessenger(
            key: PromoCodeEditingPage.scaffoldMessengerKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Vytvorenie promo kódu'),
                leading: const _AppBarLeadingWidget(),
                actions: [const _AppBarActionWidget()],
              ),
              body: const _Body(),
            ),
          )
        : const Center(
            child: SizedBox(
              height: 100,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
  }
}

class _Body extends HookWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabsCtrl = useTabController(initialLength: 2);

    final promoCodeType = useProvider(_promoCodeTypeProvider).state;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Form(
        key: useProvider(promoCodeFormKeyProvider),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PromoCodeTextField(),
            const SizedBox(height: 8),
            const UsagesCountTextField(),
            const SizedBox(height: 8),
            Text(
              'Typ promo kódu',
              style: AppTheme.headline3TextStyle,
            ),
            Column(
              children: [
                RadioListTile<PromoCodeType>(
                  title: Text('Hodnota'),
                  value: PromoCodeType.value,
                  groupValue: promoCodeType,
                  onChanged: (value) {
                    if (value != null) {
                      context.read(_promoCodeTypeProvider).state = value;
                    }
                  },
                ),
                // RadioListTile<PromoCodeType>(
                //   title: Text('Percento'),
                //   value: PromoCodeType.percent,
                //   groupValue: promoCodeType,
                //   onChanged: (value) {
                //     if (value != null) {
                //       context.read(editedPromoCodeProvider).state =
                //           context.read(editedPromoCodeProvider).state.copyWith(
                //                 discountValue: 0,
                //                 promoCodeType: PromoCodeType.percent,
                //               );
                //
                //       context.read(_promoCodeTypeProvider).state = value;
                //     }
                //   },
                // ),
              ],
            ),
            const SizedBox(height: 8),
            if (promoCodeType == PromoCodeType.value) ...[
              const MinCartPriceField(),
              const SizedBox(height: 8),
              const PromoDiscountTextField(),
            ] else if (promoCodeType == PromoCodeType.percent)
              const PromoDiscountPercentField()
          ],
        ),
      ),
    );
  }
}

class _AppBarLeadingWidget extends HookWidget {
  const _AppBarLeadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(isPromoCodeChangedProvider)
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const DiscardPromoCodeChangesDialog(),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                context.read(navigationProvider.notifier).popPage(),
          );
  }
}

class _AppBarActionWidget extends HookWidget {
  const _AppBarActionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(isPromoCodeChangedProvider)
        ? IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async => _onConfirmChanges(context),
          )
        : const SizedBox.shrink();
  }

  Future<void> _onConfirmChanges(
    BuildContext context,
  ) async {
    if (context.read(promoCodeFormKeyProvider).currentState?.validate() ??
        false) {
      final res = await showDialog<PromoCodeEditingResult>(
        context: context,
        builder: (_) => ConfirmPromoCodeChangesDialog(
          promoCode: context.read(editedPromoCodeProvider).state,
          previousCode: context.read(initialPromoCodeProvider).state,
        ),
      );

      switch (res?.result) {
        case ActionResult.success:
          context
              .read(navigationProvider.notifier)
              .popPage(ResultMessage(res!.message));
          break;
        case ActionResult.failed:
          SnackBarUtils.showSnackBar(
            PromoCodeEditingPage.scaffoldMessengerKey.currentState!,
            SnackBarDuration.short,
            res!.message,
          );
          break;
        default:
          break;
      }
    } else {
      SnackBarUtils.showSnackBar(
        PromoCodeEditingPage.scaffoldMessengerKey.currentState!,
        SnackBarDuration.long,
        AppStrings.promoCodeNotCompleteYetMsg,
      );
    }
  }
}
