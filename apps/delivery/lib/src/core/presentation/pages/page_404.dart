import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:routeborn/routeborn.dart';

class Page404 extends RoutebornPage {
  static const String pagePathBase = '404';

  Page404()
      : super.builder(
          pagePathBase,
          (_) => _PageView(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      const Right('404');

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _PageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('404'),
      ),
    );
  }
}
