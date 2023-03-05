import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/mobile_body.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:routeborn/routeborn.dart';

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

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(body: Body(), mobileBody: MobileBody());
  }
}
