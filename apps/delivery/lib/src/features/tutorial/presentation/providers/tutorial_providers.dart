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

import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((TutorialViewModel).toString());

class TutorialViewModel extends StateNotifier<int> {
  TutorialViewModel() : super(0);

  dynamic pageChanged(int index, CarouselPageChangedReason reason) {
    _logger.fine('changing index: $index reason: $reason');
    state = index;
  }

  int get currentIndex => state;

  Future<void> finishIntroScreen(BuildContext context) async {
    final user = context.read(currentUserProvider);
    if (user == null || user.introSeen) {
      context.read(navigationProvider).popPage(context);
    } else {
      await context.read(userRepositoryProvider).setUserIntroSeen();
      context.read(navigationProvider).popPage(context);
    }
  }
}

final tutorialModelProvider =
    StateNotifierProvider.autoDispose<TutorialViewModel, int>(
        (ref) => TutorialViewModel());
