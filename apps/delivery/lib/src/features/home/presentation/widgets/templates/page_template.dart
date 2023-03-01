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
import 'package:responsive_framework/responsive_framework.dart';

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
    return ResponsiveWrapper.builder(
      Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackgroundColor,
        drawer: const MenuDrawer(),
        body: CustomScrollView(
          slivers: shouldUseMobileLayout(context)
              ? <Widget>[
                  SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: MyMobileHeader(scaffoldKey: scaffoldKey)),
                  // MobileBody(),
                  mobileBody,
                  SliverToBoxAdapter(
                    child: MobileFooter(),
                  )
                ]
              : <Widget>[
                  SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: MyHeader(scaffoldKey: scaffoldKey)),
                  // Body(),
                  body,

                  SliverToBoxAdapter(
                    child: Footer(),
                  )
                ],
        ),
      ),
      maxWidth: 1920,
      minWidth: 50,
      defaultScale: true,
      breakpoints: const [
        ResponsiveBreakpoint.autoScaleDown(
          50,
          name: MOBILE,
        ),
        ResponsiveBreakpoint.autoScaleDown(600,
            name: MOBILE, scaleFactor: 0.63),
        ResponsiveBreakpoint.autoScaleDown(900,
            name: TABLET, scaleFactor: 0.63),
        ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
      ],
    );
  }
}

class MyHeader extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> scaffoldKey;
  MyHeader({Key? key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, double, bool) {
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
  Widget build(BuildContext context, double, bool) {
    return MobileHeader(
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  double maxExtent = 90;

  @override
  double minExtent = 90;
}
