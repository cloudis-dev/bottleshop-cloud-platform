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
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/tutorial/presentation/providers/tutorial_providers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class TutorialPage extends RoutebornPage {
  static const String pagePathBase = 'tutorial';

  TutorialPage()
      : super.builder(
          pagePathBase,
          (_) => _TutorialView(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right('TODO');

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _TutorialView extends HookWidget {
  const _TutorialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onBoardingViewModel = useProvider(tutorialModelProvider);
    final isLast = onBoardingViewModel == TutorialAssets.assets.length - 1;
    final carouselController = useMemoized(() => CarouselController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              disableCenter: true,
              viewportFraction: 1.0,
              onPageChanged:
                  context.read(tutorialModelProvider.notifier).pageChanged,
            ),
            items: TutorialAssets.assets
                .map(
                  (boardingAsset) => Container(
                    decoration: BoxDecoration(color: kSplashBackground),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              TutorialAssets.boardingLogo,
                              gaplessPlayback: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              boardingAsset.heroAsset,
                              gaplessPlayback: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              boardingAsset.labelAsset,
                              gaplessPlayback: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (onBoardingViewModel < TutorialAssets.assets.length - 1)
            Positioned(
              right: 20,
              top: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => context
                    .read(tutorialModelProvider.notifier)
                    .finishIntroScreen(context),
                child: Text(S.of(context).skip),
              ),
            ),
          Positioned.directional(
            start: 0.0,
            end: 0.0,
            bottom: 80.0,
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: TutorialAssets.assets
                  .map(
                    (boarding) => Container(
                      width: 25.0,
                      height: 3.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: onBoardingViewModel ==
                                TutorialAssets.assets.indexOf(boarding)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            end: 0,
            bottom: 20,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
              ),
              onPressed: () => isLast
                  ? context
                      .read(tutorialModelProvider.notifier)
                      .finishIntroScreen(context)
                  : carouselController.nextPage(curve: Curves.easeOutCubic),
              child: isLast
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(S.of(context).startShopping),
                        const Icon(Icons.arrow_forward),
                      ],
                    )
                  : Text(S.of(context).next),
            ),
          ),
        ],
      ),
    );
  }
}
