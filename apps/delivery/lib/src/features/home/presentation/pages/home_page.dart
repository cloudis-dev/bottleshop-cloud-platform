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

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/core/data/services/push_notification_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/views/home_web_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((HomePage).toString());

class HomePage extends RoutebornPage {
  static const String pagePathBase = 'home';

  HomePage()
      : super.builder(
          pagePathBase,
          (_) => const _HomeView(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.home);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _HomeView extends HookConsumerWidget {
  const _HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    useEffect(() {
      PushNotificationService.handleMessageOpenedApp(ref).then(
        (value) => _logger.fine('handleMessageOpenedApp register'),
        onError: (dynamic err, dynamic stack) =>
            _logger.severe('handleMessageOpenedApp', err, stack),
      );

      if (currentUser != null && !currentUser.isAnonymous) {
        setUserId(ref, currentUser.uid)
            .then((value) => _logger.fine('userID set'));
      }
      return;
    }, const []);

    return const HomeWebScaffold();
  }
}
