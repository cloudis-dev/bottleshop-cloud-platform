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

import 'package:delivery/src/config/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreditCards extends StatelessWidget {
  const CreditCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 25),
          width: 300,
          height: 195,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, -1)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.2)),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        isDarkMode ? kVisaBtnDark : kVisaBtn,
                        height: 60,
                        width: 80,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.2)),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        isDarkMode ? kMasterCardBtnDark : kMasterCardPayBtn,
                        height: 60,
                        width: 80,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.2)),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        isDarkMode ? kMaestroBtnDark : kMaestroBtn,
                        height: 60,
                        width: 80,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      kAmex,
                      height: 50,
                      width: 70,
                    ),
                    Image.asset(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? kApplePayMark
                          : kGooglePayMark,
                      height: 50,
                      width: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
