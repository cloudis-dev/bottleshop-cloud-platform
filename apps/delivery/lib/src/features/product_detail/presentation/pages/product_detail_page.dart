// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/language_dropdown.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/molecules/share_buttons.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/organisms/product_actions_widget.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/views/product_description_tab.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/views/product_detail_bottom_bar.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/views/product_details_tab.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/views/product_home_tab.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends HookConsumerWidget with UiLoggy {
  final ProductModel? product;
  final String? productUid;

  const ProductDetailPage({
    Key? key,
    this.product,
    this.productUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product == null) {
      return ref.watch(productProvider(productUid!)).when(
            data: (product) => product == null
                ? EmptyTab(
                    icon: Icons.info,
                    message: context.l10n.noSuchProduct,
                    buttonMessage: context.l10n.startExploring,
                    onButtonPressed: null,
                  )
                : _Body(
                    product: product,
                  ),
            loading: () => const Loader(),
            error: (err, stack) {
              loggy.error('Product CMAT: $productUid failed to load!', err, stack);

              return EmptyTab(
                icon: Icons.error_outline,
                message: context.l10n.upsSomethingWentWrong,
                buttonMessage: context.l10n.tryAgain,
                onButtonPressed: () => ref.refresh(productProvider(productUid!)),
              );
            },
          );
    } else {
      return _Body(
        product: product!,
      );
    }
  }
}

class _Body extends HookConsumerWidget {
  final ProductModel product;

  const _Body({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return shouldUseMobileLayout(context) ? _BodyMobile(product: product) : _BodyWeb(product: product);
  }
}

class _BodyWeb extends HookConsumerWidget {
  final ProductModel product;

  const _BodyWeb({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollCtrl = useScrollController();
    final authButtonKey = useMemoized(() => GlobalKey<AuthPopupButtonState>());
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    return HomePageTemplate(
      scaffoldKey: scaffoldKey,
      appBarActions: [
        const LanguageDropdown(),
        const ProductShareButton(),
        const CartAppbarButton(),
        AuthPopupButton(
          key: authButtonKey,
          scaffoldKey: scaffoldKey,
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20) + const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: ProductImage(
                          imagePath: product.imagePath,
                          overlayWidget: (imgUrl) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.zoom_in,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    launch(imgUrl);
                                  },
                                ),
                              ),
                            ),
                          ),
                          // fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            controller: scrollCtrl,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SingleChildScrollView(
                                controller: scrollCtrl,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      overflow: TextOverflow.fade,
                                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          ProductHomeTab(product: product),
                                          const SizedBox(height: 10),
                                          ProductDetailsTab(product: product),
                                          const SizedBox(height: 10),
                                          ProductDescriptionTab(product),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          child: ProductActionsWidget(
                            product: product,
                            authButtonKey: authButtonKey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyMobile extends HookConsumerWidget {
  final ProductModel product;

  const _BodyMobile({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final authButtonKey = useMemoized(() => GlobalKey<AuthPopupButtonState>());

    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: const BackButton(
              onPressed: null,
            ),
            actions: [
              AuthPopupButton(key: authButtonKey, scaffoldKey: scaffoldKey),
              // const ProductShareButton(),
            ],
            stretch: true,
            snap: false,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 450,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: ValueKey(product.uniqueId),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ProductImage(
                      imagePath: product.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      product.name,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProductHomeTab(product: product),
                  const SizedBox(height: 10),
                  ProductDetailsTab(product: product),
                  const SizedBox(height: 10),
                  ProductDescriptionTab(product),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductDetailBottomBar(
        product: product,
        authButtonKey: authButtonKey,
      ),
    );
  }
}
