import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/app_initialization/presentation/widgets/fatal_error.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((PlatformInitializationView).toString());

class PlatformInitializationView extends HookWidget {
  final Widget child;

  const PlatformInitializationView({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(platformInitializedProvider).when(
      data: (_) => child,
      loading: () => const SplashView(),
      error: (err, stack) {
        _logger.severe('Failed to initialize platform', err, stack);
        return FatalError(
          errorMessage:
              context.l10n.unfortunatelyTheApplicationWasUnableToStart,
        );
      },
    );
  }
}
