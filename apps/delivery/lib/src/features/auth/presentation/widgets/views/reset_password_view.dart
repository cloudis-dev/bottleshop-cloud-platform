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
import 'package:delivery/src/features/auth/presentation/widgets/auth_form_template.dart';
import 'package:delivery/src/features/auth/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class ResetPasswordView extends HookConsumerWidget {
  static const routeName = '/reset-password';

  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(userRepositoryProvider.select<bool>((value) => value.isLoading));
    final scrollController = useScrollController();
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      resizeToAvoidBottomInset: false,
      body: Loader(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
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
                      children: [
                        SizedBox(
                          height: AppConfig(context.l10n.appHeight(70),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned.directional(
                                textDirection: TextDirection.ltr,
                                top: 15,
                                bottom: 0,
                                start: 60,
                                end: 60,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Positioned.directional(
                                textDirection: TextDirection.ltr,
                                start: 30,
                                end: 30,
                                top: 40,
                                bottom: 0,
                                child: AuthFormTemplate(
                                  child: ResetPasswordForm(
                                    authCallback: (result) {
                                      debugPrint('res: $result');
                                      showSimpleNotification(
                                        Text(
                                          context.l10n.checkYourEmailForPasswordResetInstructions,
                                        ),
                                        position: NotificationPosition.bottom,
                                        duration: const Duration(seconds: 5),
                                        slideDismissDirection: DismissDirection.horizontal,
                                        background: Theme.of(context).primaryColor,
                                        context: context,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          context.l10n.gotNewPassword,
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            context.l10n.sign_in,
                          ),
                        ),
                      ],
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
