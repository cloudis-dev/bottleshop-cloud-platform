import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/app_navigation_drawer.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/dialogs/promo_code_delete_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/pages/promo_code_editing_page.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/promo_code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

final _messengerKey = Provider.autoDispose<GlobalKey<ScaffoldMessengerState>>(
    (_) => GlobalKey<ScaffoldMessengerState>());

class PromoCodesView extends HookWidget {
  const PromoCodesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: useProvider(_messengerKey),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kupóny'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async =>
              context.read(navigationProvider.notifier).pushPage(
                    PromoCodeEditingPage(
                        context,
                        (res) => res != null
                            ? SnackBarUtils.showResultMessageSnackbar(
                                context.read(_messengerKey).currentState, res)
                            : null,
                        null),
                  ),
          label: Text('Nový promo kód'),
          icon: Icon(Icons.add),
        ),
        drawer: const AppNavigationDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final itemsState = useProvider(
        promoCodesStreamProvider.select((value) => value.itemsState));
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 12, bottom: 60),
          sliver: SliverPagedList<PromoCodeModel>(
            itemsState: itemsState,
            itemBuilder: (context, item, _) => PromoCodeCard(
              promoCode: item,
              onPromoCodeModifyActionSelected: (item) {
                context.read(navigationProvider.notifier).pushPage(
                      PromoCodeEditingPage(
                        context,
                        (res) {
                          if (res != null) {
                            SnackBarUtils.showSnackBar(
                              context.read(_messengerKey).currentState!,
                              SnackBarDuration.short,
                              res.message,
                            );
                          }
                        },
                        item,
                      ),
                    );
              },
              onPromoCodeDeleteActionSelected: (item) async {
                final res = await showDialog<PromoCodeDeleteResult>(
                  context: context,
                  builder: (_) => PromoCodeDeleteDialog(promoCode: item),
                );

                if (res != null) {
                  SnackBarUtils.showSnackBar(
                    context.read(_messengerKey).currentState!,
                    SnackBarDuration.short,
                    res.message,
                  );
                }
              },
            ),
            requestData: () {},
          ),
        ),
      ],
    );
  }
}
