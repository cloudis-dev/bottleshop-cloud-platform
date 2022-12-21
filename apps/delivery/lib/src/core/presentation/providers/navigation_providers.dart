import 'package:delivery/src/core/data/res/routes.dart';
import 'package:delivery/src/features/categories/presentation/pages/categories_page.dart';
import 'package:delivery/src/features/favorites/presentation/pages/favorites_page.dart';
import 'package:delivery/src/features/home/presentation/pages/cart_page.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/home/presentation/pages/landing_page.dart';
import 'package:delivery/src/features/home/presentation/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

enum NestingBranch {
  landing,
  shop,
  categories,
  sale,
  wholesale,
  cart,
  favorites,
  orders,
  account,
  help,
  success,
  failure,
  search,
}

NavigationStack<NestingBranch> initialPages() => NavigationStack(
      [
        AppPageNode(
          page: HomePage(),
          crossroad: NavigationCrossroad(
            activeBranch: NestingBranch.landing,
            availableBranches: {
              NestingBranch.landing:
                  NavigationStack([AppPageNode(page: LandingPage())]),
              NestingBranch.shop:
                  NavigationStack([AppPageNode(page: ProductsPage())]),
              NestingBranch.categories:
                  NavigationStack([AppPageNode(page: CategoriesPage())]),
              NestingBranch.favorites:
                  NavigationStack([AppPageNode(page: FavoritesPage())]),
              NestingBranch.cart:
                  NavigationStack([AppPageNode(page: CartPage())]),
            },
          ),
        ),
      ],
    );

final routeInformationProvider = Provider(
  (_) => PlatformRouteInformationProvider(
    initialRouteInformation: RouteInformation(
      location: WidgetsBinding.instance.window.defaultRouteName,
    ),
  ),
);

final rootRouterDelegateProvider =
    Provider<RoutebornRootRouterDelegate<NestingBranch>>(
  (ref) => RoutebornRootRouterDelegate(
    ref.watch(navigationProvider),
    observers: [
      /* FirebaseAnalyticsObserver(
        analytics: ref.watch(analyticsProvider),
        nameExtractor: analyticsNameExtractor, // TODO: change this
      ),*/
    ],
  ),
);

final nestedRouterDelegate = Provider.family<
    RoutebornNestedRouterDelegate<NestingBranch>, NestingBranch?>(
  (ref, branch) => RoutebornNestedRouterDelegate(
    ref.watch(navigationProvider),
    branch: branch,
    observers: [
      /*FirebaseAnalyticsObserver(
        analytics: ref.watch(analyticsProvider),
        nameExtractor: analyticsNameExtractor, // TODO: change this
      ),*/
    ],
  ),
);

/// The main provider for interaction with navigation.
final navigationProvider = ChangeNotifierProvider(
  (_) => NavigationNotifier<NestingBranch>(routes),
);
