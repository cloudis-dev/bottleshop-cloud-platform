import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/features/home/data/models/open_hours_model.dart';
import 'package:delivery/src/features/home/presentation/providers/providers.dart';
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
          FutureBuilder(
            future: ref.read(openHoursStreamProvider.future),
            builder: (context, snap) {
              OpenHourModel? closing;
              if (snap.hasData) {
                (snap.data as List<OpenHourModel>).forEach((x) {
                  if (!DateUtils.dateOnly(x.dateFrom)
                          .isBefore(DateUtils.dateOnly(DateTime.now())) &&
                      !DateUtils.dateOnly(x.dateFrom)
                          .isAfter(DateUtils.dateOnly(DateTime.now())))
                    closing = x;
                });
                return closing != null ?
                 SizedBox(width: double.infinity, height: 70,child: Center(child: Padding(
                   padding: const EdgeInsets.only(left: 20, right: 20),
                   child: Text(closing!.message),
                 )),) : 
                 SizedBox.shrink();
              } else{
                return SizedBox.shrink();
              }
            }),
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
