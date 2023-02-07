// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'dart:ui';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/routes.dart';
import 'package:delivery/src/core/presentation/pages/page_404.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/app_initialization/presentation/widgets/platform_initialization_view.dart';
import 'package:delivery/src/features/app_initialization/presentation/widgets/version_check_view.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_checker_widget.dart';
import 'package:delivery/src/features/categories/presentation/providers/providers.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';
import 'package:url_launcher/url_launcher_string.dart';

class App extends HookConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load common data at the start
    ref.watch(countriesProvider);
    ref.watch(categoriesProvider);
    ref.watch(unitsProvider);
    ref.watch(orderTypesProvider);

    return const _AppBody();
  }
}

class _AppBody extends HookConsumerWidget {
  const _AppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = ref.watch(rootRouterDelegateProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp.router(
        routerDelegate: routerDelegate,
        routeInformationParser: RoutebornRouteInfoParser(
          routes: routes,
          initialStackBuilder: initialPages,
          page404: Page404(),
        ),
        scrollBehavior:
            ScrollConfiguration.of(context).copyWith(scrollbars: false),
        backButtonDispatcher: RootBackButtonDispatcher(),
        routeInformationProvider: ref.watch(routeInformationProvider),
        builder: (context, router) => OverlaySupport.global(
          child: PlatformInitializationView(
            child: VersionCheckView(
              checkSuccessWidgetBuilder: (context) => AuthCheckerWidget(
                successViewBuilder: (context) => _RouterWidget(router!),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => context.l10n.app_title,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: ref.watch(currentLanguageProvider).language2Locale(),
        theme: appTheme,
        darkTheme: appThemeDark,
        themeMode: ref.watch(currentThemeModeProvider),
      ),
    );
  }
}

class _RouterWidget extends HookConsumerWidget {
  final Widget router;

  const _RouterWidget(this.router, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      String? error =
          ref.watch(userRepositoryProvider.select((value) => value.error));
      useEffect(
        () {
          if (!ref.read(sharedPreferencesProvider).getHasAgeVerified()) {
            _showDialog(context, ref, const AgeVerificationDialog());
          } else if (error != null && error.isNotEmpty) {
            _showDialog(context, ref, UnsuccessfulLoginAttemptDialog(error));
          }
          return;
        },
        const [],
      );
    }
    return router;
  }

  void _showDialog(BuildContext context, WidgetRef ref, Widget dialog) {
    final rootNavKey = ref.read(navigationProvider).rootNavKey;

    Future.doWhile(
      () async {
        if (rootNavKey.currentContext == null) {
          await Future<void>.delayed(const Duration(microseconds: 1));
          return true;
        }
        return false;
      },
    ).then(
      (_) => showDialog<void>(
        context: rootNavKey.currentContext!,
        builder: (_) => dialog,
        barrierDismissible: false,
      ),
    );
  }
}

class AgeVerificationDialog extends HookConsumerWidget {
  const AgeVerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(context.l10n.ageValidationDialogTitle),
        content: Text(context.l10n.ageValidationDialogLabel),
        actions: [
          TextButton(
            onPressed: () =>
                launchUrlString('about:blank', webOnlyWindowName: '_self'),
            child: Text(context.l10n.ageValidationDialogButtonNo),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(sharedPreferencesProvider)
                  .setHasAgeVerified(verified: true);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(context.l10n.ageValidationDialogButtonYes),
          ),
        ],
      ),
    );
  }
}

class UnsuccessfulLoginAttemptDialog extends HookConsumerWidget {
  final String error;
  const UnsuccessfulLoginAttemptDialog(this.error, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(context.l10n.error.toUpperCase()),
        content: Text(error),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(context.l10n.close),
          ),
        ],
      ),
    );
  }
}
