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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/routes.dart';
import 'package:delivery/src/core/presentation/pages/page_404.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/app_initialization/presentation/widgets/platform_initialization_view.dart';
import 'package:delivery/src/features/app_initialization/presentation/widgets/version_check_view.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_checker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends HookWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = useProvider(rootRouterDelegateProvider);

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
        routeInformationProvider: useProvider(routeInformationProvider),
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
        onGenerateTitle: (context) => S.of(context).app_title,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: useProvider<Locale>(currentLocaleProvider),
        theme: appTheme,
        darkTheme: appThemeDark,
        themeMode: useProvider<ThemeMode>(currentThemeModeProvider),
      ),
    );
  }
}

class _RouterWidget extends HookWidget {
  final Widget router;

  const _RouterWidget(this.router, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      useEffect(
        () {
          if (!context.read(sharedPreferencesProvider).getHasAgeVerified()) {
            final rootNavKey = context.read(navigationProvider).rootNavKey;

            Future.doWhile(
              () async {
                if (rootNavKey.currentContext == null) {
                  await Future<void>.delayed(Duration(microseconds: 1));
                  return true;
                }
                return false;
              },
            ).then(
              (_) => showDialog<void>(
                context: rootNavKey.currentContext!,
                builder: (_) => const AgeVerificationDialog(),
                barrierDismissible: false,
              ),
            );
          }
          return;
        },
        const [],
      );
    }

    return router;
  }
}

class AgeVerificationDialog extends HookWidget {
  const AgeVerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(S.of(context).ageValidationDialogTitle),
        content: Text(S.of(context).ageValidationDialogLabel),
        actions: [
          TextButton(
            onPressed: () => launch('about:blank', webOnlyWindowName: '_self'),
            child: Text(S.of(context).ageValidationDialogButtonNo),
          ),
          ElevatedButton(
            onPressed: () async {
              await context
                  .read(sharedPreferencesProvider)
                  .setHasAgeVerified(verified: true);

              Navigator.of(context).pop();
            },
            child: Text(S.of(context).ageValidationDialogButtonYes),
          ),
        ],
      ),
    );
  }
}
