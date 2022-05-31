import 'package:delivery/src/core/utils/flutter_scroll_to_top/scroll_wrapper.dart';
import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/filtered_products_with_sticky_header.dart';
import 'package:delivery/src/features/home/presentation/widgets/home_slider.dart';
import 'package:delivery/src/features/home/presentation/widgets/page_body_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/sliver_all_products.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/flash_sales_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/new_arrivals_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/recommended_section.dart';
import 'package:delivery/src/features/product_sections/presentation/widgets/views/sale_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class _Body extends HookConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnyFilterActive = ref.watch(
        appliedFilterProvider(FilterType.allProducts)
            .select<bool>((value) => value.isAnyFilterActive));
    final scrollCtrl = useScrollController();

    final children = [
      const SliverToBoxAdapter(child: FlashSalesSection()),
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      if (shouldUseMobileLayout(context))
        MultiSliver(children: const [
          SliverToBoxAdapter(child: SaleSection()),
          SliverToBoxAdapter(child: SizedBox(height: 8)),
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
