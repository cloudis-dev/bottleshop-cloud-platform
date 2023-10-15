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

import 'package:delivery/src/core/presentation/pages/page_404.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/account/presentation/pages/account_page.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/reset_password_view.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/terms_conditions_view.dart';
import 'package:delivery/src/features/categories/presentation/pages/categories_page.dart';
import 'package:delivery/src/features/checkout/presentation/pages/checkout_page.dart';
import 'package:delivery/src/features/checkout/presentation/pages/stripe_checkout_failure.dart';
import 'package:delivery/src/features/checkout/presentation/pages/stripe_checkout_success.dart';
import 'package:delivery/src/features/favorites/presentation/pages/favorites_page.dart';
import 'package:delivery/src/features/help/presentation/pages/help_page.dart';
import 'package:delivery/src/features/home/presentation/pages/cart_page.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/home/presentation/pages/landing_page.dart';
import 'package:delivery/src/features/home/presentation/pages/products_page.dart';
import 'package:delivery/src/features/orders/presentation/pages/order_detail_page.dart';
import 'package:delivery/src/features/orders/presentation/pages/orders_page.dart';
import 'package:delivery/src/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:delivery/src/features/products/presentation/pages/category_products_detail_page.dart';
import 'package:delivery/src/features/sale/presentation/pages/sale_page.dart';
import 'package:delivery/src/features/search/presentation/pages/products_search_page.dart';
import 'package:delivery/src/features/tutorial/presentation/pages/tutorial_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routeborn/routeborn.dart';

final _categoryDetailRoutes = <String, RouteNode<NestingBranch>>{
  CategoryProductsPage.pagePathBase: RouteNode(
    const ParametrizedPage(CategoryProductsPage.fromPathParams),
    routes: {
      ProductDetailPage.pagePathBase: RouteNode(
        const ParametrizedPage(ProductDetailPage.fromPathParams),
      ),
    },
  ),
};

final routes = <String, RouteNode<NestingBranch>>{
  HomePage.pagePathBase: RouteNode(
    NonParametrizedPage(() => HomePage()),
    nestedBranches: NestedBranches(
      defaultBranch: NestingBranch.landing,
      branches: {
        NestingBranch.landing: BranchInitNode(
          LandingPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => LandingPage()),
          ),
        ),
        NestingBranch.shop: BranchInitNode(
          ProductsPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => ProductsPage()),
            routes: {
              ProductDetailPage.pagePathBase: RouteNode(
                const ParametrizedPage(ProductDetailPage.fromPathParams),
              ),
            },
          ),
        ),
        NestingBranch.categories: BranchInitNode(
          CategoriesPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => CategoriesPage()),
            routes: {..._categoryDetailRoutes},
          ),
        ),
        NestingBranch.sale: BranchInitNode(
          SalePage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => SalePage()),
            routes: {
              ProductDetailPage.pagePathBase: RouteNode(
                const ParametrizedPage(ProductDetailPage.fromPathParams),
              ),
            },
          ),
        ),
        NestingBranch.favorites: BranchInitNode(
          FavoritesPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => FavoritesPage()),
            routes: {
              ProductDetailPage.pagePathBase: RouteNode(
                const ParametrizedPage(ProductDetailPage.fromPathParams),
              ),
            },
          ),
        ),
        NestingBranch.cart: BranchInitNode(
          CartPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => CartPage()),
            routes: {
              CheckoutPage.pagePathBase:
                  RouteNode(NonParametrizedPage(() => CheckoutPage())),
            },
          ),
        ),
        NestingBranch.search: BranchInitNode(
          ProductsSearchPage.pagePathBase,
          RouteNode(
            NonParametrizedPage(() => ProductsSearchPage()),
            routes: {
              ..._categoryDetailRoutes,
              ProductDetailPage.pagePathBase: RouteNode(
                const ParametrizedPage(ProductDetailPage.fromPathParams),
              ),
            },
          ),
        ),
        NestingBranch.orders: BranchInitNode(
          OrdersPage.pagePathBase,
          RouteNode<NestingBranch>(
            NonParametrizedPage(() => OrdersPage()),
            routes: {
              OrderDetailPage.pagePathBase: RouteNode(
                const ParametrizedPage(OrderDetailPage.fromPathParams),
              )
            },
          ),
        ),
        NestingBranch.account: BranchInitNode(
          AccountPage.pagePathBase,
          RouteNode(NonParametrizedPage(() => AccountPage())),
        ),
        NestingBranch.help: BranchInitNode(
          HelpPage.pagePathBase,
          RouteNode(NonParametrizedPage(() => HelpPage())),
        ),
        NestingBranch.success: BranchInitNode(
            StripeCheckoutSuccessPage.pagePathBase,
            RouteNode(NonParametrizedPage(() => StripeCheckoutSuccessPage()))),
        NestingBranch.failure: BranchInitNode(
            StripeCheckoutFailurePage.pagePathBase,
            RouteNode(NonParametrizedPage(() => StripeCheckoutFailurePage()))),
      },
    ),
    routes: {
      TutorialPage.pagePathBase:
          RouteNode(NonParametrizedPage(() => TutorialPage())),
      TermsConditionsPage.pagePathBase:
          RouteNode(NonParametrizedPage(() => TermsConditionsPage())),
      // FeedbackPage.pagePathBase:
      //     RouteNode(NonParametrizedPage(() => FeedbackPage())),
    },
  ),
  Page404.pagePathBase: RouteNode(NonParametrizedPage(() => Page404())),
};

class AppRoutes {
  static Route<dynamic> onGenerateVerticalRoute(RouteSettings settings) {
    switch (settings.name) {
      // case AccountPage.routeName:
      //   return _getPageRoute(
      //     settings: settings,
      //     viewToShow: AccountPage(),
      //     fullScreen: true,
      //   );
      // case OrdersPage.routeName:
      //   return _getPageRoute(
      //       settings: settings, viewToShow: OrdersPage(), fullScreen: true);
      // case OrderDetailPage.routeName:
      //   return _getPageRoute(settings: settings, viewToShow: OrderDetailPage());
      // case TermsConditionsPage.routeName:
      // return _getPageRoute(
      //     settings: settings,
      //     viewToShow: TermsConditionsView(),
      //     fullScreen: true);
      // case TutorialView.routeName:
      //   return _getPageRoute(
      //       settings: settings, viewToShow: TutorialView(), fullScreen: true);
      // case HelpPage.routeName:
      //   return _getPageRoute(
      //       settings: settings, viewToShow: HelpPage(), fullScreen: true);
      case ResetPasswordView.routeName:
        throw UnimplementedError();
      default:
        throw UnimplementedError();
      //   return _getPageRoute(
      //       settings: settings, viewToShow: ResetPasswordView());
      // default:
      //   return _getPageRoute(
      //     viewToShow: FatalError(errorMessage: 'Route does not exist'),
      //     fullScreen: true,
      //   );
    }
  }

  // static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  // case ProductsSearchPage.routeName:
  //   return _getPageRoute(
  //       settings: settings, viewToShow: ProductsSearchPage());
  // case CategoryProductsDetailPage.routeName:
  //   return _getPageRoute(
  //       settings: settings, viewToShow: CategoryProductsDetailPage());
  // case ProductDetailPage.routeName:
  //   return _getPageRoute(
  //       settings: settings, viewToShow: ProductDetailPage());
  // case ShippingDetailsPage.routeName:
  //   return _getPageRoute(
  //       settings: settings, viewToShow: ShippingDetailsPage());
  // case CheckoutPage.routeName:
  //   return _getPageRoute(settings: settings, viewToShow: CheckoutPage());
  // case CheckoutDoneView.routeName:
  //   return _getPageRoute(
  //     settings: settings,
  //     viewToShow: CheckoutDoneView(),
  //     fullScreen: true,
  //   );
  // default:
  // return _getPageRoute(
  //   viewToShow: FatalError(errorMessage: 'Route does not exist'),
  //   fullScreen: true,
  // );
  //   }
  // }

  // static PageRoute _getPageRoute(
  //     {RouteSettings? settings, Widget? viewToShow, fullScreen = false}) {
  //   if (defaultTargetPlatform == TargetPlatform.iOS) {
  //     return CupertinoPageRoute(
  //       builder: (_) => viewToShow!,
  //       settings: settings,
  //       fullscreenDialog: fullScreen,
  //     );
  //   }
  //   return MaterialPageRoute<dynamic>(
  //     settings: settings,
  //     builder: (_) => viewToShow!,
  //     fullscreenDialog: fullScreen,
  //   );
  // }
}
