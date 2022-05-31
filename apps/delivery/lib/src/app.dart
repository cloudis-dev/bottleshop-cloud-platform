import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/app_theme.dart';
import 'package:delivery/src/core/data/repositories/common_data_repository.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/sign_in_page.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/splash_view.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/tutorial/presentation/pages/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vrouter/vrouter.dart';

class App extends HookConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VMaterialApp(
      child: VRouter(
        beforeEnter: ((vRedirector) async {
          await ref.read(commonDataRepositoryProvider).init();
        }),
        routes: [
          VWidget(path: '/login', widget: const SplashView()),
          VWidget(path: '/', widget: const SignInPage()),
          VWidget(path: '/tutorial', widget: const TutorialPage()),
          VWidget(path: '/home', widget: const HomePage()),
        ],
        debugShowCheckedModeBanner: false,
        mode: VRouterMode.history,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        onGenerateTitle: (context) => context.l10n.app_title,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: ref.watch<Locale>(currentLocaleProvider),
        theme: appTheme,
        darkTheme: appThemeDark,
        themeMode: ref.watch<ThemeMode>(currentThemeModeProvider),
      ),
    );
  }
}
