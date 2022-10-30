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

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class SocialMediaButtonsRow extends HookConsumerWidget {
  final bool isAppleSupported;
  final ValueChanged<bool> authCallback;
  final bool enabled;

  const SocialMediaButtonsRow({
    Key? key,
    required this.authCallback,
    required this.enabled,
    this.isAppleSupported = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _SocialMediaButtonWrapper(
          child: InkWell(
            onTap: () async {
              if (enabled) {
                try {
                  final result = await ref
                      .read(userRepositoryProvider)
                      .signUpWithFacebook(context);
                  authCallback(result);
                } catch (e) {
                  authCallback(false);
                }
              } else {
                _notifyTermsNotAgreed(context);
              }
            },
            child: Image.asset('assets/images/facebook.png'),
          ),
        ),
        const SizedBox(width: 10),
        _SocialMediaButtonWrapper(
          child: InkWell(
            onTap: () async {
              if (enabled) {
                final result = await ref
                    .read(userRepositoryProvider)
                    .signUpWithGoogle(context);
                authCallback(result);
              } else {
                _notifyTermsNotAgreed(context);
              }
            },
            child: Image.asset('assets/images/google_logo.png'),
          ),
        ),
        const SizedBox(width: 10),
        if (isAppleSupported) ...[
          _SocialMediaButtonWrapper(
            child: Builder(
              builder: (context) => InkWell(
                onTap: () async {
                  if (enabled) {
                    final result = await ref
                        .read(userRepositoryProvider)
                        .signUpWithApple(context);
                    authCallback(result);
                  } else {
                    _notifyTermsNotAgreed(context);
                  }
                },
                child: Image.asset('assets/images/apple_login.png'),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        _SocialMediaButtonWrapper(
          child: InkWell(
            onTap: () async {
              if (enabled) {
                final result = await ref
                    .read(userRepositoryProvider)
                    .signUpAnonymously(context);
                authCallback(result);
              } else {
                _notifyTermsNotAgreed(context);
              }
            },
            child: Image.asset('assets/images/anonymous.png'),
          ),
        ),
      ],
    );
  }

  void _notifyTermsNotAgreed(BuildContext context) {
    showSimpleNotification(
      Text(
        context.l10n.youMustFirstAgreeToTermsConditions,
        style: const TextStyle(color: Colors.white),
      ),
      background: Theme.of(context).colorScheme.onSecondary,
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 2),
      slideDismissDirection: DismissDirection.horizontal,
      context: context,
    );
  }
}

class _SocialMediaButtonWrapper extends StatelessWidget {
  final Widget child;
  const _SocialMediaButtonWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: child,
    );
  }
}
