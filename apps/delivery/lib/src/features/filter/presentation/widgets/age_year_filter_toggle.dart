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
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgeYearFilterToggle extends HookConsumerWidget {
  const AgeYearFilterToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(filterTypeScopedProvider);

    final isFilterByAge = ref.watch(filterModelProvider(filterType).select<bool>((value) => value.isFilterByAge));
    final isYearOrAgeActive =
        ref.watch(filterModelProvider(filterType).select<bool>((value) => value.isYearActive || value.isAgeActive));

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      height: 40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const borderWidth = 1;

          return ToggleButtons(
            constraints: BoxConstraints.expand(width: (constraints.maxWidth - borderWidth * 3) / 2),
            isSelected: [isFilterByAge, !isFilterByAge],
            onPressed: (id) => ref.read(filterModelProvider(filterType).state).state =
                ref.read(filterModelProvider(filterType).state).state.copyWith(
                      isFilterByAge: id == 0,
                    ),
            borderRadius: BorderRadius.circular(2),
            fillColor: isYearOrAgeActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            borderWidth: borderWidth.toDouble(),
            children: [
              Text(
                context.l10n.age,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                context.l10n.years,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          );
        },
      ),
    );
  }
}
