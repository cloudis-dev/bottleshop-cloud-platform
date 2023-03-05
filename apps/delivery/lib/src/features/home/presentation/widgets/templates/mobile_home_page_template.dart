import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_header.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class MobileHomePageTemplate extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final Widget? filterBtn;

  const MobileHomePageTemplate({
    Key? key,
    required this.scaffoldKey,
    required this.body,
    this.filterBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          MobileHeader(
            scaffoldKey: scaffoldKey,
            filterBtn: filterBtn,
          ),
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
