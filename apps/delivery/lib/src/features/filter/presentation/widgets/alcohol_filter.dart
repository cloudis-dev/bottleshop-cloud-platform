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
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:delivery/src/features/filter/utils/filters_formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlcoholFilter extends HookConsumerWidget {
  const AlcoholFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(filterTypeScopedProvider);

    final alcoholRange = ref.watch(filterModelProvider(filterType).select<RangeValues>((value) => value.alcoholRange));
    final isAlcoholActive = ref.watch(filterModelProvider(filterType).select<bool>((value) => value.isAlcoholActive));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.alcohol),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: isAlcoholActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                FilterFormattingUtils.getAlcoholRangeString(alcoholRange),
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
        RangeSlider(
          activeColor: Theme.of(context).colorScheme.secondary,
          min: FilterConstants.minAlcohol.toDouble(),
          max: FilterConstants.maxAlcohol.toDouble(),
          divisions: FilterConstants.alcoholDivisions,
          values: alcoholRange,
          onChanged: (value) {
            ref.read(filterModelProvider(filterType).state).state =
                ref.read(filterModelProvider(filterType).state).state.copyWith(
                      alcoholRange: value,
                    );
          },
          labels: RangeLabels(
            '${alcoholRange.start.round()}%',
            '${alcoholRange.end.round()}%',
          ),
        ),
      ],
    );
  }
}
