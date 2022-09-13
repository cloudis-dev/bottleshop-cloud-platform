import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/result_message.dart';
import 'package:bottleshop_admin/src/core/utils/logical_utils.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/dialogs/discard_product_changes_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/dialogs/product_confirm_changes_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_images_view.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_information_view.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// (product_uid, productAction)
final _pageContextProvider =
    ScopedProvider<Tuple2<String?, ProductAction>>(null);

class ProductEditPage extends AppPage {
  ProductEditPage({
    String? productUid,
    required ProductAction productAction,
    void Function(ResultMessage?)? onPopped,
  })  : assert(LogicalUtils.implication(
          productAction == ProductAction.creating,
          productUid == null,
        )),
        super(
          productAction == ProductAction.creating
              ? 'product/new'
              : 'edit/$productUid',
          (context) => ProviderScope(
            overrides: [
              _pageContextProvider
                  .overrideWithValue(Tuple2(productUid, productAction)),
            ],
            child: _ProductEditView(),
          ),
          pageArgs: Tuple2(productUid, productAction),
          onPopped: onPopped,
        );

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

class _ProductEditView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initialProductProvider);
    useProvider(editedProductProvider);
    useProvider(productFormStateKeyProvider);
    useProvider(isProductModelChangedProvider);
    useProvider(isCreatingNewProductProvider);

    useProvider(productImgProvider);
    useProvider(isImgLoadedProvider);
    useProvider(isProductImageValid);
    useProvider(isImgChangedProvider);

    return const _PageContent();
  }
}

class _PageContent extends HookWidget {
  const _PageContent();

  @override
  Widget build(BuildContext context) {
    final pageContext = useProvider(_pageContextProvider);

    return useProvider(productToEditStreamProvider(pageContext.item1))
        .maybeWhen(
      data: (product) => _ProductEditBody(product, pageContext.item2),
      orElse: () => Scaffold(
        appBar: AppBar(
          title: const Text('Detail produktu'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: context.read(navigationProvider.notifier).popPage,
          ),
        ),
        body: const Center(
          child: SizedBox(
            height: 100,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductEditBody extends HookWidget {
  final List<Widget> navigationTabs = [
    Tab(text: 'INFORMÁCIE'),
    Tab(text: 'OBRÁZOK'),
  ];

  final ProductModel initialProduct;
  final ProductAction productAction;

  _ProductEditBody(this.initialProduct, this.productAction);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return ScaffoldMessenger(
      key: ProductEditPage.scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail produktu'),
          leading: const _AppBarLeadingWidget(),
          actions: [
            _ConfirmChangesButton(
              onConfirmChanges: _onConfirmChanges,
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: TabBar(
              tabs: navigationTabs,
              controller: tabController,
            ),
          ),
        ),
        body: Form(
          key: useProvider(productFormStateKeyProvider),
          child: TabBarView(
            controller: tabController,
            children: [
              const ProductInformationView(),
              const ProductImagesView(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirmChanges(
    BuildContext context,
    bool isCreatingNewProduct,
  ) async {
    if (context.read(productFormStateKeyProvider).currentState!.validate() &&
        context
            .read(isProductImageValid)
            .maybeWhen(data: (val) => val, orElse: () => false)) {
      final res = await showDialog<ProductEditingResult>(
        context: context,
        builder: (_) => ProductConfirmChangesDialog(
          isCreatingNewProduct: isCreatingNewProduct,
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
            ProductEditPage.scaffoldMessengerKey.currentState!,
            SnackBarDuration.short,
            res!.message,
          );
          break;
        default:
          break;
      }
    } else {
      SnackBarUtils.showSnackBar(
        ProductEditPage.scaffoldMessengerKey.currentState!,
        SnackBarDuration.short,
        AppStrings.productNotValidYetMsg,
      );
    }
  }
}

class _AppBarLeadingWidget extends HookWidget {
  const _AppBarLeadingWidget({Key? key}) : super(key: key);

  void onBackButton(BuildContext context, bool isModelChanged) {
    if (isModelChanged) {
      showDialog<void>(
        context: context,
        builder: (_) => const DiscardProductChangesDialog(),
      );
    } else {
      context.read(navigationProvider.notifier).popPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChanged = useProvider(isProductModelChangedProvider);

    return IconButton(
      icon: Icon(isChanged ? Icons.close : Icons.arrow_back),
      onPressed: () => onBackButton(context, isChanged),
    );
  }
}

class _ConfirmChangesButton extends HookWidget {
  const _ConfirmChangesButton({
    Key? key,
    required this.onConfirmChanges,
  }) : super(key: key);

  final Future<void> Function(
    BuildContext context,
    bool isCreatingNewProduct,
  ) onConfirmChanges;

  @override
  Widget build(BuildContext context) {
    final isChanged = useProvider(isProductModelChangedProvider);
final b = useProvider(blop);
    if (isChanged) {
      return useProvider(isProductImageValid).maybeWhen(
        data: (_) => IconButton(
          icon: const Icon(Icons.check),
          onPressed: () async => onConfirmChanges(
            context,
            context.read(isCreatingNewProductProvider),
          ),
        ),
        orElse: () => Padding(
          padding: const EdgeInsets.all(12),
          child: AspectRatio(
            aspectRatio: 1,
            child:
                const CircularProgressIndicator(backgroundColor: Colors.white),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
