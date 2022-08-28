import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/app_initialization/presentation/providers/providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _logger = Logger((VersionCheckView).toString());

class VersionCheckView extends HookWidget {
  final WidgetBuilder checkSuccessWidgetBuilder;

  const VersionCheckView({
    Key? key,
    required this.checkSuccessWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: useProvider(isAppVersionCompatible).when(
        data: (isCompatible) => isCompatible
            ? checkSuccessWidgetBuilder(context)
            : const _WrongAppVersionView(),
        loading: () => const SplashView(),
        error: (err, stack) {
          _logger.severe('Failed to check app version compatible', err, stack);
          return checkSuccessWidgetBuilder(context);
        },
      ),
    );
  }
}

class _WrongAppVersionView extends HookWidget {
  const _WrongAppVersionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: kSplashBackground),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.youreUsingAnIncompatibleVersionOfTheApp,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          useProvider(appDownloadRedirectUrlProvider).when(
            data: (url) => SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => launchUrlString(url),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    context.l10n.downloadTheUpdate,
                  ),
                ),
              ),
            ),
            loading: () => const Loader(),
            error: (err, stack) {
              _logger.severe('Failed to get app download url', err, stack);
              return Text(context.l10n.somethingWentWrong);
            },
          )
        ],
      ),
    );
  }
}
