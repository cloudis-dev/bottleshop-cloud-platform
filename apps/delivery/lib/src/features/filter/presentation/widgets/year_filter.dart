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
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:delivery/src/features/filter/utils/filters_formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((YearFilter).toString());

class YearFilter extends HookWidget {
  const YearFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterType = useProvider(filterTypeScopedProvider);

    final maxYear = useProvider(
        filterModelProvider(filterType).select((value) => value.state.maxYear));
    final isYearActive = useProvider(filterModelProvider(filterType)
        .select((value) => value.state.isYearActive));

    return Offstage(
      offstage: useProvider(
        filterModelProvider(filterType)
            .select((value) => value.state.isFilterByAge),
      ),
      child: useProvider(filterAggregationsProvider).when(
        data: (aggs) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).year),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration: BoxDecoration(
                    color: isYearActive
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    FilterFormattingUtils.getYearRangeString(
                        aggs.minYear, maxYear),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            Slider(
              min: aggs.minYear!.toDouble(),
              max: FilterConstants.maxYear.toDouble(),
              divisions: FilterConstants.maxYear - aggs.minYear!,
              value: maxYear.toDouble(),
              onChanged: (value) => context
                      .read(filterModelProvider(filterType))
                      .state =
                  context.read(filterModelProvider(filterType)).state.copyWith(
                        maxYear: value.round(),
                      ),
              label: maxYear.toString(),
              activeColor: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
        loading: () => const Loader(),
        error: (err, stack) {
          _logger.severe('Failed to fetch filter aggregations', err, stack);

          return Center(
            child: Text(S.of(context).error),
          );
        },
      ),
    );
  }
}
