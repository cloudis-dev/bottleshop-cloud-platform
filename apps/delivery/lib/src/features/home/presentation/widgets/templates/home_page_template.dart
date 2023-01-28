import 'package:badges/badges.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/breadcrumbs.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePageTemplate extends ConsumerWidget {
  final Key? scaffoldKey;
  final Widget body;

  final List<Widget> appBarActions;
  final PreferredSizeWidget? appBarBottom;

  const HomePageTemplate({
    Key? key,
    this.scaffoldKey,
    required this.body,
    this.appBarBottom,
    this.appBarActions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: appBarActions,
        bottom: appBarBottom,
        title: Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButtonTheme.of(context).style!.merge(
                    TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
            ),
          ),
          child: Row(
            children: [
              MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: () {
                    final nav = ref.read(navigationProvider);

                    if (nav.getNestingBranch(context) == NestingBranch.shop) {
                      nav.replaceAllWith(context, []);
                    } else {
                      nav.setNestingBranch(context, NestingBranch.shop);
                    }
                  },
                  child: Image.asset(
                    kLogoTransparent,
                    height: 50,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const HomeAppBarButton(),
              const CategoriesAppBarButton(),
              const WholeSaleAppBarButton(),
              const OrdersAppBarButton(),
              const SaleAppBarButton(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const Breadcrumbs(),
          Expanded(
            child: ClipRect(
              child: OverlaySupport.local(child: body),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppBarButton extends ConsumerWidget {
  const HomeAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.homeTabLabel),
      onPressed: () {
        final nav = ref.read(navigationProvider);
        if (nav.getNestingBranch(context) == NestingBranch.shop) {
          nav.replaceAllWith(context, []);
        } else {
          nav.setNestingBranch(
            context,
            NestingBranch.shop,
            resetBranchStack: true,
          );
        }
      },
    );
  }
}

class CategoriesAppBarButton extends ConsumerWidget {
  const CategoriesAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.categories),
      onPressed: () {
        final nav = ref.read(navigationProvider);
        if (nav.getNestingBranch(context) == NestingBranch.categories) {
          nav.replaceAllWith(context, []);
        } else {
          nav.setNestingBranch(
            context,
            NestingBranch.categories,
          );
        }
      },
    );
  }
}

class WholeSaleAppBarButton extends ConsumerWidget {
  const WholeSaleAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.wholesale),
      onPressed: () {
        final nav = ref.read(navigationProvider);
        if (nav.getNestingBranch(context) == NestingBranch.wholesale) {
          nav.replaceAllWith(context, []);
        } else {
          nav.setNestingBranch(context, NestingBranch.wholesale);
        }
      },
    );
  }
}

class OrdersAppBarButton extends HookConsumerWidget {
  const OrdersAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Text(context.l10n.orderTabLabel);

    return TextButton(
      onPressed: () {
        final nav = ref.read(navigationProvider);
        if (nav.getNestingBranch(context) == NestingBranch.orders) {
          nav.replaceAllWith(context, []);
        } else {
          nav.setNestingBranch(
            context,
            NestingBranch.orders,
          );
        }
      },
      child: ref.watch(activeOrdersCountProvider).maybeWhen(
            data: (count) => BottleshopBadge(
              showBadge: count > 0,
              badgeText: count.toString(),
              position: BadgePosition.topEnd(end: -15, top: -10),
              child: child,
            ),
            orElse: () => child,
          ),
    );
  }
}

class SaleAppBarButton extends ConsumerWidget {
  const SaleAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.sale),
      onPressed: () {
        final nav = ref.read(navigationProvider);
        if (nav.getNestingBranch(context) == NestingBranch.sale) {
          nav.replaceAllWith(context, []);
        } else {
          nav.setNestingBranch(context, NestingBranch.sale);
        }
      },
    );
  }
}
