import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeWebScaffold extends HookWidget {
  const HomeWebScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: useProvider(nestedRouterDelegate(null)),
    );
  }
}
