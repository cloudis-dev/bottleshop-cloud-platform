import 'package:bottleshop_admin/app_page.dart';
import 'package:bottleshop_admin/providers/auth_providers.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/app_activity.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tab_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'intro_activity_providers.dart';
import 'views/loading_view/loading_view.dart';
import 'views/sign_in_view/sign_in_view.dart';
import 'views/signing_in_loading_view.dart';

class IntroActivityPage extends AppPage {
  IntroActivityPage({List<AppPage> Function()? onPagesAfterLogin})
      : super(
          '/intro',
          (_) => _IntroActivity(onPagesAfterLogin ??
              () => [AppActivityPage(initialIndex: TabIndex.home)]),
          pageArgs: onPagesAfterLogin,
        );
}

class _IntroActivity extends HookWidget {
  _IntroActivity(this._onPagesAfterLogin);

  final List<AppPage> Function() _onPagesAfterLogin;

  @override
  Widget build(BuildContext context) {
    final authStateChanges = useProvider(authStateChangesProvider);

    return authStateChanges.when(
      data: (adminUser) {
        if (adminUser == null) {
          return SignInView();
        } else {
          // context.read(loggedUserProvider).state = adminUser;
          final userProvider = context.read(loggedUserProvider);
          Future.microtask(() => userProvider.state = adminUser);

          return LoadingView(_onPagesAfterLogin);
        }
      },
      loading: () => SignInLoadingView(),
      error: (e, __) {
        final signInModel = context.read(signInModelProvider.notifier);
        Future.microtask(
            () => signInModel.error = signInModel.dispatchAuthException(e));
        return SignInView();
      },
    );
  }
}
