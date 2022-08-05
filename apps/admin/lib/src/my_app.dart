import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

final _isAppVersionCompatible = StreamProvider<bool>(
  (ref) {
    return ref
        .watch(commonDataRepositoryProvider)
        .minVersionStream()
        .asyncMap((minBuildNum) async {
      final packageInfo = await PackageInfo.fromPlatform();
      print(packageInfo.version);

      return Version.parse(packageInfo.version) >= Version.parse(minBuildNum!);
    });
  },
);

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navKey = GlobalKey();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigatorObserver =
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorObservers: <NavigatorObserver>[navigatorObserver],
      title: 'Bottleshop Admin',
      theme: AppTheme.theme,
      home: const _PlatformInitBody(),
    );
  }
}

class _PlatformInitBody extends HookWidget {
  const _PlatformInitBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: useProvider(platformInitializedProvider).when(
        data: (_) {
          return const _VersionCheckBody();
        },
        loading: () => const _LoadingWidget(),
        error: (err, _) => Text('An error occured $err'),
      ),
    );
  }
}

class _VersionCheckBody extends HookWidget {
  const _VersionCheckBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(_isAppVersionCompatible).when(
      data: (isVersionCompatible) {
        if (isVersionCompatible) {
          return const _AppBody();
        } else {
          return const _WrongVersionWidget();
        }
      },
      loading: () => const _LoadingWidget(),
      error: (err, stack) {
        FirebaseCrashlytics.instance.recordError(err, stack);
        return Text('An error occured.');
      },
    );
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Unfocus(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            // res means if anything was popped
            /*final res = */ await MyApp.navKey.currentState!.maybePop();
            return Future.value(false);
          },
          child: Consumer(
            builder: (context, watch, child) {
              final pages = watch(navigationProvider);

              print(pages);
              return Navigator(
                key: MyApp.navKey,
                pages: pages,
                onPopPage: (route, dynamic result) {
                  final res =
                      context.read(navigationProvider.notifier).popPage();
                  if (res) return route.didPop(result);
                  return false;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Credits to: @rrousselGit
class _Unfocus extends StatelessWidget {
  const _Unfocus({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: child,
      );
}

class _WrongVersionWidget extends StatelessWidget {
  const _WrongVersionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppTheme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Používate nekompatabilnú verziu aplikácie',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () =>
                launch('https://appdistribution.firebase.google.com'),
            child: Text('Stiahnuť aktualizáciu'),
          )
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppTheme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Načítavanie',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}
