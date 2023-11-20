import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

abstract class AppPage extends Page<dynamic> {
  /// [pageArgs] parameter is used to distinguish each page instance
  AppPage(
    this.pageName,
    this.builder, {
    dynamic pageArgs,
    this.onPopped,
  }) : super(
          key: _createKey(pageName, pageArgs),
          name: pageName,
        );

  static LocalKey _createKey<T>(String name, T? pageArgs) {
    return ValueKey(pageArgs != null ? Tuple2(name, pageArgs) : name);
  }

  final WidgetBuilder builder;
  final String pageName;

  /// This is a callback that is called when the page is popped.
  final Function? onPopped;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    if (kIsWeb || Platform.isAndroid) {
      return MaterialPageRoute<dynamic>(settings: this, builder: builder);
    } else {
      return CupertinoPageRoute<dynamic>(settings: this, builder: builder);
    }
  }
}
