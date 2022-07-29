import 'package:bottleshop_admin/constants/app_strings.dart';
import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/features/discount/presentation/discount_setup_dialog.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/features/section_flash_sales/presentation/providers/providers.dart';
import 'package:bottleshop_admin/models/product_model.dart';
import 'package:bottleshop_admin/result_message.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tabs_views/sections_view/sections_view.dart';
import 'package:bottleshop_admin/ui/shared_widgets/my_popup_menu_item.dart';
import 'package:bottleshop_admin/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _Action {
  removeFromFlash,
  edit,
  discount,
}

void _onActionSelected(
  BuildContext context,
  _Action action,
  ProductModel product,
) {
  final messengerState = SectionsView.scaffoldMessengerKey.currentState;

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
    case _Action.removeFromFlash:
      context
          .read(flashSaleProductsRepository)
          .removeFromFlashSale(product)
          .then(
            (value) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromFlashSaleMsg),
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

class ProductCardFlashSaleMenuButton extends StatelessWidget {
  final ProductModel product;

  const ProductCardFlashSaleMenuButton(this.product, {Key? key})
      : super(key: key);

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
                    text: 'Flash Sale',
                    style: TextStyle(
                      color: AppTheme.flashSaleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Icon(Icons.highlight_remove_rounded),
            _Action.removeFromFlash,
          ),
        ],
      );
}
