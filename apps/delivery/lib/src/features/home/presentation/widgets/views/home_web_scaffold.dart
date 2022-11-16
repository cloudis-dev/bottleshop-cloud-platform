import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeWebScaffold extends HookConsumerWidget {
  const HomeWebScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Router(
      routerDelegate: ref.watch(nestedRouterDelegate(null)),
    );
  }
}
