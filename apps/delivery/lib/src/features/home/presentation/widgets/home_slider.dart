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
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/config/app_config.dart';
import 'package:delivery/src/features/home/data/models/slider_model.dart';
import 'package:delivery/src/features/home/presentation/providers/providers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger((HomeSliderl10n.toString());

const aspect = 16 / 7.5;

class HomeSlider extends HookWidget {
  @literal
  const HomeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Carousel();
  }
}

class _Carousel extends HookConsumerWidget {
  @literal
  const _Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabSlidesState = useState(0);
    final sliderList = ref.watch(homeSliderProvider);

    final ctrl = useMemoized(() => CarouselController(), const []);

    return AspectRatio(
      aspectRatio: aspect,
      child: sliderList.when(
        data: (value) {
          return Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: CarouselSlider.builder(
                  carouselController: ctrl,
                  options: CarouselOptions(
                    aspectRatio: aspect,
                    autoPlayCurve: Curves.easeOut,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) =>
                        tabSlidesState.value = index,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                  itemCount: value.length,
                  itemBuilder: (context, index, realIndex) {
                    return _SliderItem(value[index]);
                  },
                ),
              ),
              Positioned(
                bottom: 25,
                right: 41,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: value.map((slide) {
                    final idx = value.indexOf(slide);

                    return GestureDetector(
                      onTap: () => ctrl.animateToPage(idx),
                      child: Container(
                        color: Colors.transparent,
                        height: 25,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: tabSlidesState.value == idx
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }l10n.toList(),
                ),
              ),
            ],
          );
        },
        loading: () => const Loader(),
        error: (err, stack) {
          loggy.error('Failed to home slider', err, stack);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 200),
                Text(context.l10n.error),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliderItem extends HookConsumerWidget {
  final SliderModel sliderModel;

  const _SliderItem(this.sliderModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(sliderModel.getImageUrl(currentLocale)),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
            offset: const Offset(0, 4),
            blurRadius: 9,
          ),
        ],
      ),
      child: Container(
        alignment: AlignmentDirectional.bottomEnd,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: AppConfig(context.l10n.appWidth(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                sliderModel.getDescription(currentLocale),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.right,
                overflow: TextOverflow.fade,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
