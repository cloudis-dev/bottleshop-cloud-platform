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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Loader extends StatelessWidget {
  final bool inAsyncCall;
  final Widget? child;
  final Color valueColor;

  @literal
  const Loader({
    Key? key,
    this.inAsyncCall = false,
    this.child,
    this.valueColor = const Color(0xFFF9AA33),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Stack(
        children: [
          child!,
          if (inAsyncCall) ...[
            const Opacity(
              child: ModalBarrier(dismissible: false, color: Colors.grey),
              opacity: 0.4,
            ),
            ModalProgressIndicator(
              valueColor: valueColor,
            ),
          ]
        ],
      );
    } else {
      return AdaptiveLoader(
        valueColor: valueColor,
      );
    }
  }
}

class ModalProgressIndicator extends StatelessWidget {
  final Color valueColor;

  @literal
  const ModalProgressIndicator({Key? key, required this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            child: AdaptiveLoader(
              valueColor: valueColor,
            ),
            height: 30.0,
            width: 30.0,
          ),
        ),
      ),
    );
  }
}

class AdaptiveLoader extends StatelessWidget {
  final Color? valueColor;

  @literal
  const AdaptiveLoader({Key? key, this.valueColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
      ),
    );
  }
}
