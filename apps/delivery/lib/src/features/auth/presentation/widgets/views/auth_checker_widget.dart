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

import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/auth/data/repositories/user_repository.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/sign_in_view.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/splash_view.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/verify_email_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthCheckerWidget extends HookConsumerWidget {
  final WidgetBuilder successViewBuilder;

  const AuthCheckerWidget({
    Key? key,
    required this.successViewBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final authStatus = ref.watch(authStatusProvider);
    final isLoading =
        ref.watch(userRepositoryProvider.select((value) => value.isLoading));

    switch (authStatus) {
      case AuthStatus.unauthenticated:
        if (kIsWeb) {
          return successViewBuilder(context);
        } else {
          return const SignInView();
        }
      case AuthStatus.authenticating:
        if (kIsWeb) {
          return const Scaffold(body: Loader());
        } else {
          return const SignInView();
        }
      case AuthStatus.authenticated:
        if (isLoading) {
          return const SplashView();
        }

        if (currentUser == null ||
            currentUser.isAnonymous ||
            currentUser.isEmailVerified) {
          // TODO: This is completely broken crashes app every single time - refactor needed
          /*useEffect(
            () {
              if (!(currentUser?.introSeen ?? true)) {
                Future.microtask(
                  () => context.read(navigationProvider).pushPage(
                        context,
                        AppPageNode(page: TutorialPage()),
                      ),
                );
              }
              return null;
            },
            const [],
          );*/

          return successViewBuilder(context);
        } else {
          return const VerifyEmailView();
        }
      case AuthStatus.uninitialized:
      default:
        return const SplashView();
    }
  }
}
