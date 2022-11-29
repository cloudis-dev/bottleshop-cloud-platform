import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/widgets/menu.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_body.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_footer.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:routeborn/routeborn.dart';
import '../widgets/landing/footer.dart';
import '../widgets/landing/header.dart';

class LandingPage extends RoutebornPage {
  static const String pagePathBase = 'landing';

  LandingPage()
      : super.builder(
          pagePathBase,
          (_) => const _LandingPage(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.landing);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _LandingPage extends StatelessWidget {
  const _LandingPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        backgroundColor: kBackgroundColor,
        drawer: const Menu(),
        body: CustomScrollView(
          slivers: shouldUseMobileLayout(context)
              ? <Widget>[
                  SliverPersistentHeader(
                      pinned: true, floating: true, delegate: MyMobileHeader()),
                  SliverToBoxAdapter(child: MobileBody()),
                  SliverToBoxAdapter(
                    child: MobileFooter(),
                  )
                ]
              : <Widget>[
                  SliverPersistentHeader(
                      pinned: true, floating: true, delegate: MyHeader()),
                  SliverToBoxAdapter(child: Body()),
                  SliverToBoxAdapter(
                    child: Footer(),
                  )
                ],
        ),
      ),
      maxWidth: 1920,
      minWidth: 50,
      defaultScale: true,
      breakpoints: [
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
  @override
  Widget build(BuildContext context, double, bool) {
    return Header();
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
  @override
  Widget build(BuildContext context, double, bool) {
    return MobileHeader();
  }

  @override
  double maxExtent = 90;

  @override
  double minExtent = 90;
}
