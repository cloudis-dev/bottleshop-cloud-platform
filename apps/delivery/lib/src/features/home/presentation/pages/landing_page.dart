import 'package:delivery/src/features/home/presentation/widgets/landing/body.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../widgets/landing/footer.dart';
import '../widgets/landing/header.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

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
