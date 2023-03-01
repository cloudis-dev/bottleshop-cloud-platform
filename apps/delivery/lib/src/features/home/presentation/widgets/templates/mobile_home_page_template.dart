import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_header.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MobileHomePageTemplate extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  Widget? filterBtn;

  MobileHomePageTemplate({
    Key? key,
    required this.scaffoldKey,
    required this.body,
    this.filterBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        key: scaffoldKey,
        drawer: MenuDrawer(),
        body: Column(children: [
          ResponsiveWrapper(
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
            child: ResponsiveConstraints(
              child: MobileHeader(
                scaffoldKey: scaffoldKey,
                filterBtn: filterBtn,
              ),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: OverlaySupport.local(child: body),
            ),
          ),
        ]));
  }
}
