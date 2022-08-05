import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/my_popup_menu_item.dart';
import 'package:bottleshop_admin/src/core/result_message.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/discount/presentation/dialogs/discount_setup_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/section_new_entries/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/sections/presentation/pages/sections_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _Action {
  edit,
  removeFromNewEntry,
  discount,
}

void _onActionSelected(
  BuildContext context,
  _Action action,
  ProductModel product,
) {
  final messengerState = SectionsPage.scaffoldMessengerKey.currentState;

  switch (action) {
    case _Action.edit:
      context.read(navigationProvider.notifier).pushPage(
            ProductEditPage(
              productUid: product.uniqueId,
              productAction: ProductAction.editing,
              onPopped: (res) => res != null
                  ? SnackBarUtils.showResultMessageSnackbar(messengerState, res)
                  : null,
            ),
          );
      break;
    case _Action.discount:
      showDialog<ResultMessage>(
        context: context,
        builder: (_) => DiscountSetupDialog(
          product: product,
        ),
      ).then(
        (value) => value != null
            ? SnackBarUtils.showResultMessageSnackbar(messengerState, value)
            : null,
      );
      break;
    case _Action.removeFromNewEntry:
      context
          .read(newEntryProductsRepositoryProvider)
          .removeProductFromNewEntries(product)
          .then(
            (value) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromNewEntriesMsg),
            ),
          )
          .catchError(
            (_) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
  }
}

class ProductCardNewEntryMenuButton extends StatelessWidget {
  final ProductModel product;

  const ProductCardNewEntryMenuButton(
    this.product, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuButton<_Action>(
        icon: Icon(Icons.more_vert, size: 32),
        onSelected: (selection) => _onActionSelected(
          context,
          selection,
          product,
        ),
        itemBuilder: (context) => <PopupMenuEntry<_Action>>[
          MyPopUpMenuItem(
            Text(
              'Upraviť',
              style: AppTheme.popupMenuItemTextStyle,
            ),
            Icon(Icons.mode_edit),
            _Action.edit,
          ),
          MyPopUpMenuItem(
            Text(
              'Zľava',
              style: AppTheme.popupMenuItemTextStyle,
            ),
            Icon(Icons.attach_money),
            _Action.discount,
          ),
          MyPopUpMenuItem(
            RichText(
              text: TextSpan(
                text: 'Odstrániť z ',
                style: AppTheme.popupMenuItemTextStyle,
                children: [
                  TextSpan(
                    text: 'Novinky',
                    style: TextStyle(
                      color: AppTheme.newEntryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Icon(Icons.highlight_remove_rounded),
            _Action.removeFromNewEntry,
          ),
        ],
      );
}
