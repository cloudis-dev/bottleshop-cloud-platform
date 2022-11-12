import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body.dart';
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
    return Container(
        decoration: new BoxDecoration(
          color: Color(0xff0C0C0C),
        ),
        child: ResponsiveWrapper.builder(
          CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                  pinned: true, floating: true, delegate: MyHeader()),
              Body(),
              SliverToBoxAdapter(
                child: Footer(),
              )
            ],
          ),
          maxWidth: 1920,
          minWidth: 500,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(500,
                name: MOBILE, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScaleDown(900,
                name: TABLET, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
          ],
        ));
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
