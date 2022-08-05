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
import 'package:bottleshop_admin/src/features/products/presentation/dialogs/product_delete_confirmation_dialog.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/repositories/flash_sale_products_repository.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/section_new_entries/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/section_recommended/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/section_sale/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _Action {
  update,
  discount,
  addToFlashSale,
  removeFromFlashSale,
  addToSale,
  removeFromSale,
  addToNewEntry,
  removeFromNewEntry,
  addToRecommended,
  removeFromRecommended,
  delete,
}

void _onActionSelected(
  BuildContext context,
  _Action action,
  ProductModel product,
) {
  final messengerState = ScaffoldMessenger.of(context);

  switch (action) {
    case _Action.update:
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
    case _Action.addToFlashSale:
      // TODO: here will be flash sale selection where the produc will be added - PostMVP
      context
          .read(flashSalesRepository)
          .getFlashSaleStream()
          .first
          .then(
            (flashSale) => context
                .read(flashSaleProductsRepository)
                .addToFlashSale(product, flashSale),
          )
          .then(
            (value) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productAddedToFlashSaleMsg),
            ),
          )
          .catchError(
            (dynamic err) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(
                (err as NoDiscountOnProductForFlashSaleException).message,
              ),
            ),
            test: (e) => e is NoDiscountOnProductForFlashSaleException,
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.removeFromFlashSale:
      context
          .read(flashSaleProductsRepository)
          .removeFromFlashSale(product)
          .then(
            (_) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromFlashSaleMsg),
            ),
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.addToSale:
      context
          .read(saleProductsRepositoryProvider)
          .addProductToSale(product)
          .then(
            (value) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productAddedToSaleMsg),
            ),
          )
          .catchError(
            (_) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.removeFromSale:
      context
          .read(saleProductsRepositoryProvider)
          .removeProductFromSale(product)
          .then(
            (value) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromSaleMsg),
            ),
          )
          .catchError(
            (_) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.addToNewEntry:
      context
          .read(newEntryProductsRepositoryProvider)
          .addProductToNewEntries(product)
          .then(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productAddedToNewEntriesMsg),
            ),
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.removeFromNewEntry:
      context
          .read(newEntryProductsRepositoryProvider)
          .removeProductFromNewEntries(product)
          .then(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromNewEntriesMsg),
            ),
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.addToRecommended:
      context
          .read(recommendedProductsRepositoryProvider)
          .addProductToRecommended(product)
          .then(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productAddedToRecommendedMsg),
            ),
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.removeFromRecommended:
      context
          .read(recommendedProductsRepositoryProvider)
          .removeProductFromRecommended(product)
          .then(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.productRemovedFromRecommendedMsg),
            ),
          )
          .catchError(
            (dynamic _) => SnackBarUtils.showResultMessageSnackbar(
              messengerState,
              ResultMessage(AppStrings.unknownErrorMsg),
            ),
          );
      break;
    case _Action.delete:
      showDialog<ProductDeleteResult>(
        context: context,
        builder: (_) => ProductDeleteConfirmationDialog(
          product: product,
        ),
      ).then(
        (value) {
          if (value != null) {
            SnackBarUtils.showSnackBar(
              messengerState,
              SnackBarDuration.short,
              value.message,
            );
          }
        },
      );
  }
}

/// A menu button with all the options to be done with a product.
class ProductCardAllActionsMenuButton extends StatelessWidget {
  final ProductModel product;

  const ProductCardAllActionsMenuButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuButton<_Action>(
        icon: Icon(Icons.more_vert, size: 32),
        onSelected: (selection) =>
            _onActionSelected(context, selection, product),
        itemBuilder: (context) => <PopupMenuEntry<_Action>>[
          MyPopUpMenuItem(
            Text(
              'Upraviť',
              style: AppTheme.popupMenuItemTextStyle,
            ),
            Icon(Icons.mode_edit),
            _Action.update,
          ),
          MyPopUpMenuItem(
            Text(
              'Zľava',
              style: AppTheme.popupMenuItemTextStyle,
            ),
            Icon(Icons.attach_money),
            _Action.discount,
          ),
          if (!product.isFlashSale)
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Pridať do ',
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
              Icon(Icons.add),
              _Action.addToFlashSale,
              !product.isInAnySection,
            )
          else
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
              _Action.removeFromFlashSale,
            ),
          if (!product.isSale)
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Pridať do ',
                  style: AppTheme.popupMenuItemTextStyle,
                  children: [
                    TextSpan(
                      text: 'Výpredaj',
                      style: TextStyle(
                        color: AppTheme.saleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.add),
              _Action.addToSale,
              !product.isInAnySection,
            )
          else
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Odstrániť z ',
                  style: AppTheme.popupMenuItemTextStyle,
                  children: [
                    TextSpan(
                      text: 'Výpredaj',
                      style: TextStyle(
                        color: AppTheme.saleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.highlight_remove_rounded),
              _Action.removeFromSale,
            ),
          if (!product.isNewEntry)
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Pridať do ',
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
              Icon(Icons.add),
              _Action.addToNewEntry,
              !product.isInAnySection,
            )
          else
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
          if (!product.isRecommended)
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Pridať do ',
                  style: AppTheme.popupMenuItemTextStyle,
                  children: [
                    TextSpan(
                      text: 'Odporúčané',
                      style: TextStyle(
                        color: AppTheme.recommendedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.add),
              _Action.addToRecommended,
              !product.isInAnySection,
            )
          else
            MyPopUpMenuItem(
              RichText(
                text: TextSpan(
                  text: 'Odstrániť z ',
                  style: AppTheme.popupMenuItemTextStyle,
                  children: [
                    TextSpan(
                      text: 'Odporúčané',
                      style: TextStyle(
                        color: AppTheme.recommendedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.highlight_remove_rounded),
              _Action.removeFromRecommended,
            ),
          MyPopUpMenuItem(
            Text(
              'Odstrániť',
              style:
                  AppTheme.popupMenuItemTextStyle.copyWith(color: Colors.red),
            ),
            Icon(Icons.delete),
            _Action.delete,
          ),
        ],
      );
}
