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

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/adaptive_alert_dialog.dart';
import 'package:delivery/src/features/auth/presentation/widgets/atoms/terms_and_conditions_text_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TermsAndConditionsDialog extends HookWidget {
  const TermsAndConditionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveAlertDialog(
      content: SingleChildScrollView(
        child: TermsAndConditionsTextContent(
          onNavigateToTermsPage: () {
            throw UnimplementedError();
          },
        ),
      ),
      title: Text(S.of(context).termsTitleMainScreen),
      actions: defaultTargetPlatform == TargetPlatform.iOS
          ? [
              CupertinoDialogAction(
                child: Text(S.of(context).termsPopUpNo),
                onPressed: () => Navigator.pop(context, false),
                isDefaultAction: true,
                textStyle: Theme.of(context).textTheme.subtitle2,
              ),
              CupertinoDialogAction(
                child: Text(S.of(context).termsPopUpYes),
                onPressed: () => Navigator.pop(context, true),
                textStyle: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ]
          : [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  S.of(context).termsPopUpNo,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  S.of(context).termsPopUpYes,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
    );
  }
}
