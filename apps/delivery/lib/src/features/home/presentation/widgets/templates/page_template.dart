import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/footer.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/header.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_footer.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageTemplate extends HookConsumerWidget {
  final Widget body;
  final Widget mobileBody;

  const PageTemplate({
    Key? key,
    required this.body,
    required this.mobileBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackgroundColor,
      drawer: const MenuDrawer(),
      body: CustomScrollView(
        slivers: shouldUseMobileLayout(context)
            ? <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: MyMobileHeader(scaffoldKey: scaffoldKey),
                ),
                mobileBody,
                SliverToBoxAdapter(
                  child: MobileFooter(),
                )
              ]
            : <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: MyHeader(scaffoldKey: scaffoldKey),
                ),
                body,
                SliverToBoxAdapter(
                  child: Footer(),
                )
              ],
      ),
    );
  }
}

class MyHeader extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> scaffoldKey;
  MyHeader({Key? key, required this.scaffoldKey});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Header(
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double maxExtent = 118;

  @override
  double minExtent = 118;
}

class MyMobileHeader extends MyHeader {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MyMobileHeader({Key? key, required this.scaffoldKey})
      : super(scaffoldKey: scaffoldKey);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return MobileHeader(
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  double maxExtent = 90;

  @override
  double minExtent = 90;
}
