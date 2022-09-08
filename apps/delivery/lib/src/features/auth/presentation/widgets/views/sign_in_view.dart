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
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/app_config.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/sign_in_form.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/terms_and_conditions_tile.dart';
import 'package:delivery/src/features/auth/presentation/widgets/templates/auth_form_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class SignInView extends HookWidget {
  static const String routeName = '/sign-in';

  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInToggled = useProvider<bool>(widgetToggleProvider);
    final scrollController = useScrollController();
    final isLoading =
        useProvider(userRepositoryProvider.select((value) => value.isLoading));
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Loader(
          inAsyncCall: isLoading,
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return CupertinoScrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottom),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: AppConfig(context).appHeight(70),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned.directional(
                                  textDirection: TextDirection.ltr,
                                  start: 30,
                                  end: 30,
                                  top: 40,
                                  bottom: 0,
                                  child: AuthFormTemplate(
                                    child: SignInForm(
                                      authCallback: signInToggled
                                          ? (result) {
                                              if (result == false) {
                                                var error = context
                                                    .read(
                                                        userRepositoryProvider)
                                                    .error!;
                                                context
                                                    .read(
                                                        userRepositoryProvider)
                                                    .handleFatalFailure();
                                                showSimpleNotification(
                                                  Text(error.isNotEmpty
                                                      ? error
                                                      : 'Fatal error'),
                                                  position: NotificationPosition
                                                      .bottom,
                                                  background: Theme.of(context)
                                                      .errorColor,
                                                  slideDismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  context: context,
                                                );
                                              }
                                            }
                                          : (result) {
                                              var error = context
                                                  .read(userRepositoryProvider)
                                                  .error;
                                              if (!result) {
                                                showSimpleNotification(
                                                  Text(error!),
                                                  position: NotificationPosition
                                                      .bottom,
                                                  background: Theme.of(context)
                                                      .errorColor,
                                                  slideDismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  context: context,
                                                );
                                              }
                                            },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const TermsAndConditionsTile(),
                          Text(
                            signInToggled
                                ? context.l10n.dontHaveAnAccount
                                : context.l10n.account_already,
                          ),
                          TextButton(
                            onPressed: () => context
                                .read(widgetToggleProvider.notifier)
                                .toggle(),
                            child: Text(
                              !signInToggled
                                  ? context.l10n.sign_in
                                  : context.l10n.sign_up,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
