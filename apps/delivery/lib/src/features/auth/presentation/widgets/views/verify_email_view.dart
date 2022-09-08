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

import 'dart:async';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class VerifyEmailView extends HookWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 5), (_) async {
        await context.read(userRepositoryProvider).checkUserVerified();
      });
      return timer.cancel;
    }, const []);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: kSplashBackground),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.pleaseVerifyYourEmail,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Image.asset(kLogo)),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await context
                        .read(userRepositoryProvider)
                        .sendVerificationMail()
                        .whenComplete(
                          () => showSimpleNotification(
                            Text(context.l10n.confirmationEmailSent),
                            position: NotificationPosition.bottom,
                            slideDismissDirection: DismissDirection.horizontal,
                            context: context,
                          ),
                        );
                  } catch (e) {
                    showSimpleNotification(
                      Text(context.l10n.confirmationEmailNotSent),
                      position: NotificationPosition.bottom,
                      slideDismissDirection: DismissDirection.horizontal,
                      background: Theme.of(context).errorColor,
                      context: context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.resendVerificationEmail),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await context.read(userRepositoryProvider).signOut();
                  } catch (e) {
                    // TODO
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.logOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
