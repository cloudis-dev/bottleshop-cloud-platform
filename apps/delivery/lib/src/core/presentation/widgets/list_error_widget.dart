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
import 'package:flutter/material.dart';

/// This is used in scrollable lists where the content is loaded.
/// When any error in the items loading happens, this widget should be displayed.
class ListErrorWidget extends StatelessWidget {
  const ListErrorWidget(this.onButtonPressed, {Key? key}) : super(key: key);

  final void Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            S.of(context).somethingWentWrong,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: onButtonPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: const StadiumBorder(),
              primary: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              S.of(context).tryAgain,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
