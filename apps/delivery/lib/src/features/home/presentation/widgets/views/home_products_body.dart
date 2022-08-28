import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/home/presentation/slivers/sliver_all_products.dart';
import 'package:delivery/src/features/home/presentation/widgets/filtered_products_with_sticky_header.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/home_slider.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/flash_sales_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/new_arrivals_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/recommended_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/sale_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeProductsBody extends HookWidget {
  final GlobalKey<DrawerStateAcquirerState> drawerAcquirerKey;

  final GlobalKey<ScaffoldState> scaffoldKey;

  @literal
  const HomeProductsBody(
    this.scaffoldKey,
    this.drawerAcquirerKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: FilterDrawer(
        filterType: FilterType.allProducts,
        drawerAcquirerKey: drawerAcquirerKey,
      ),
      body: const _Body(),
    );
  }
}

class _Body extends HookWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAnyFilterActive = useProvider(
        appliedFilterProvider(FilterType.allProducts)
            .select((value) => value.state.isAnyFilterActive));
    final scrollCtrl = useScrollController();

    final children = [
      const SliverToBoxAdapter(child: FlashSalesSection()),
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      if (shouldUseMobileLayout(context))
        MultiSliver(children: [
          const SliverToBoxAdapter(child: SaleSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ]),
      const SliverToBoxAdapter(child: NewArrivalsSection()),
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      const SliverToBoxAdapter(child: RecommendedSection()),
      const SliverToBoxAdapter(child: SizedBox(height: 32)),
      const SliverAllProducts(),
    ];

    if (isAnyFilterActive) {
      return const FilteredProductsWithStickyHeader();
    } else {
      return ScrollWrapper(
        promptAlignment: Alignment.topCenter,
        scrollController: scrollCtrl,
        promptScrollOffset: 1500,
        child: CupertinoScrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: HomeSlider(),
                ),
              ),
              if (shouldUseMobileLayout(context))
                ...children
              else
                PageBodyTemplateSliver(
                  sliver: MultiSliver(
                    children: children,
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}
