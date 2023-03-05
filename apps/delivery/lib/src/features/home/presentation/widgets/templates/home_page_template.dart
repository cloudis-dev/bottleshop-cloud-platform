import 'package:delivery/src/features/home/presentation/widgets/landing/header.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePageTemplate extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final Widget? filterBtn;

  const HomePageTemplate({
    Key? key,
    required this.scaffoldKey,
    required this.body,
    this.filterBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [
          Header(
            scaffoldKey: scaffoldKey,
            filterBtn: filterBtn,
          ),
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
