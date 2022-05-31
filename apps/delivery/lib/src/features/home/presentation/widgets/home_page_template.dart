import 'package:badges/badges.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/home/presentation/widgets/breadcrumbs.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePageTemplate extends HookConsumerWidget {
  final Key? scaffoldKey;
  final Widget body;

  final List<Widget> appBarActions;
  final PreferredSizeWidget? appBarBottom;

  const HomePageTemplate({
    super.key,
    this.scaffoldKey,
    required this.body,
    this.appBarBottom,
    this.appBarActions = const [],
  });

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
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
            ),
          ),
          child: Row(
            children: [
              MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: () {},
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
      onPressed: () {},
    );
  }
}

class CategoriesAppBarButton extends ConsumerWidget {
  const CategoriesAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.categories),
      onPressed: () {},
    );
  }
}

class WholeSaleAppBarButton extends ConsumerWidget {
  const WholeSaleAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text(context.l10n.wholesale),
      onPressed: () {},
    );
  }
}

class OrdersAppBarButton extends HookConsumerWidget {
  const OrdersAppBarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Text(context.l10n.orderTabLabel);

    return TextButton(
      onPressed: () {},
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
      onPressed: () {},
    );
  }
}
