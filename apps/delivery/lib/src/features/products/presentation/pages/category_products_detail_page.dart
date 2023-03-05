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

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/presentation/pages/page_404.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/categories/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/filter_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/search_icon_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/products/presentation/slivers/sliver_category_detail_app_bar.dart';
import 'package:delivery/src/features/products/presentation/widgets/category_products_list.dart';
import 'package:delivery/src/features/products/presentation/widgets/subcategories_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class CategoryProductsPage extends RoutebornPage with UpdatablePageNameMixin {
  static const String pagePathBase = 'category_products';

  static Tuple2<RoutebornPage, List<String>> fromPathParams(
    List<String> remainingPathArguments,
  ) {
    if (remainingPathArguments.isNotEmpty) {
      return Tuple2(
        CategoryProductsPage.uid(remainingPathArguments.first),
        remainingPathArguments.skip(1).toList(),
      );
    }

    return Tuple2(Page404(), remainingPathArguments);
  }

  final String categoryId;

  CategoryProductsPage.uid(this.categoryId) : super(pagePathBase) {
    builder = (context) => _CategoryProductsPageView(
          categoryUid: categoryId,
          subcategoryId: null,
          categoryImgHeroTag: null,
          setPageName: (pageName) => setPageName(context, pageName),
        );
  }

  CategoryProductsPage(
    CategoriesTreeModel category, {
    int? subcategoryId,
    String? categoryImgHeroTag,
  })  : categoryId = category.categoryDetails.id,
        super(pagePathBase) {
    builder = (context) => _CategoryProductsPageView(
          category: category,
          subcategoryId: subcategoryId,
          categoryImgHeroTag: categoryImgHeroTag,
          setPageName: (pageName) => setPageName(context, pageName),
        );
  }

  @override
  String getPagePath() => '$pagePathBase/$categoryId';

  @override
  String getPagePathBase() => pagePathBase;
}

class _CategoryProductsPageView extends HookConsumerWidget {
  final CategoriesTreeModel? category;
  final String? categoryUid;

  /// In case null, the `All` category is opened
  final int? subcategoryId;
  final String? categoryImgHeroTag;

  final SetPageNameCallback setPageName;

  const _CategoryProductsPageView({
    Key? key,
    this.category,
    this.categoryUid,
    required this.subcategoryId,
    required this.categoryImgHeroTag,
    required this.setPageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return category == null
        ? ref.watch(categoryProvider(categoryUid!)).maybeWhen(
              data: (e) => _Body(
                category: e,
                subcategoryId: subcategoryId,
                categoryImgHeroTag: categoryImgHeroTag,
                setPageName: setPageName,
              ),
              loading: () => const Loader(),
              orElse: () => EmptyTab(
                icon: Icons.info,
                message: context.l10n.noSuchCategory,
                buttonMessage: context.l10n.startExploring,
                onButtonPressed: () {
                  ref.read(navigationProvider).replaceAllWith(context, []);
                },
              ),
            )
        : _Body(
            category: category!,
            subcategoryId: subcategoryId,
            categoryImgHeroTag: categoryImgHeroTag,
            setPageName: setPageName,
          );
  }
}

class _Body extends HookConsumerWidget {
  final CategoriesTreeModel category;

  /// In case null, the `All` category is opened
  final int? subcategoryId;
  final String? categoryImgHeroTag;

  final SetPageNameCallback setPageName;

  const _Body({
    Key? key,
    required this.category,
    required this.subcategoryId,
    required this.categoryImgHeroTag,
    required this.setPageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final drawerAcquirerKey =
        useMemoized(() => GlobalKey<DrawerStateAcquirerState>());
    final tabController = subcategoryId == null && !category.hasSubcategories
        ? null
        : useTabController(
            initialLength:
                category.subCategories.length + 1, // Adding the 'all' tab
            initialIndex: subcategoryId ?? 0,
          );
    final currentLang = ref.watch(currentLanguageProvider);

    setPageName(category.categoryDetails.getName(currentLang));

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        endDrawer: FilterDrawer(
          filterType: FilterType.categoryProducts,
          drawerAcquirerKey: drawerAcquirerKey,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverCategoryDetailAppBar(
                category: category,
                tabController: tabController,
                categoryImgHeroTag:
                    categoryImgHeroTag ?? category.categoryDetails.id,
                actions: [
                  FilterIconButton(scaffoldKey, drawerAcquirerKey),
                  IconButton(
                    icon:
                        Hero(tag: UniqueKey(), child: const Icon(Icons.search)),
                    onPressed: () =>
                        ref.read(navigationProvider).setNestingBranch(
                              context,
                              NestingBranch.search,
                              resetBranchStack: true,
                              branchParam: ref
                                  .read(navigationProvider)
                                  .getNestingBranch(context),
                            ),
                  ),
                  AuthPopupButton(scaffoldKey: scaffoldKey),
                ],
              ),
            ),
          ],
          body: CategoryProductsBody(
            category,
            tabController: tabController,
          ),
        ),
      );
    } else {
      final bodyScaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        body: Scaffold(
          key: bodyScaffoldKey,
          endDrawer: FilterDrawer(
            filterType: FilterType.categoryProducts,
            drawerAcquirerKey: drawerAcquirerKey,
          ),
          body: PageBodyTemplate(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: const SliverToBoxAdapter(),
                )
              ],
              body: CategoryProductsBody(
                category,
                tabController: tabController,
                // scrollCtrl: scrollCtrl,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class CategoryProductsBody extends StatelessWidget {
  final TabController? tabController;
  final CategoriesTreeModel category;

  const CategoryProductsBody(
    this.category, {
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tabController == null
        ? CategoryProductsList(
            category: category,
            isAllCategory: true,
          )
        : TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              // This for the whole category (all subcategories)
              CategoryProductsList(
                category: category,
                isAllCategory: true,
              ),
              ...category.subCategories.map(
                (subCategory) => CategoryProductsList(
                  category: subCategory,
                  isAllCategory: false,
                ),
              )
            ],
          );
  }
}
