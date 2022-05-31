import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckView extends HookConsumerWidget with UiLoggy {
  final WidgetBuilder checkSuccessWidgetBuilder;

  const VersionCheckView({
    Key? key,
    required this.checkSuccessWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(isAppVersionCompatible).when(
            data: (isCompatible) => isCompatible
                ? checkSuccessWidgetBuilder(context)
                : const _WrongAppVersionView(),
            loading: () => const SplashView(),
            error: (err, stack) {
              loggy.error('Failed to check app version compatible', err, stack);
              return checkSuccessWidgetBuilder(context);
            },
          ),
    );
  }
}

class _WrongAppVersionView extends HookConsumerWidget with UiLoggy {
  const _WrongAppVersionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          ref.watch(appDownloadRedirectUrlProvider).when(
                data: (url) => SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                      shape: const StadiumBorder(),
                    ),
                    // ignore: deprecated_member_use
                    onPressed: () => launch(url),
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
                  loggy.error('Failed to get app download url', err, stack);
                  return Text(context.l10n.somethingWentWrong);
                },
              )
        ],
      ),
    );
  }
}
