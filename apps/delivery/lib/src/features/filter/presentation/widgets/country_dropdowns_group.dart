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
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/iterable_extension.dart';
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CountryDropdownsFilterGroup).toString());

class CountryDropdownsFilterGroup extends HookWidget {
  const CountryDropdownsFilterGroup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterType = useProvider(filterTypeScopedProvider);

    final countriesFilter = useProvider(filterModelProvider(filterType)
        .select((value) => value.state.countries));

    final currentLocale = useProvider(currentLocaleProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).onlyFollowingCountries),
          const SizedBox(height: 16),
          ...useProvider(filterAggregationsProvider).when(
            data: (aggs) {
              final selectableCountries = aggs.usedCountries
                  .toSet()
                  .difference(countriesFilter.toSet())
                  .toList()
                ..sort(
                  (a, b) => SortingUtil.countryCompare(a, b, currentLocale),
                );

              return List<Widget>.generate(
                countriesFilter.length + (selectableCountries.isEmpty ? 0 : 1),
                (id) => _CountryDropdownFilter(
                  id: id,
                  selectableCountries: selectableCountries,
                ),
              ).interleave(const SizedBox(height: 8)).toList();
            },
            loading: () => [const Loader()],
            error: (err, stack) {
              _logger.severe('Failed to fetch filter aggregations', err, stack);
              return [Text(S.of(context).error)];
            },
          ),
        ],
      ),
    );
  }
}

class _CountryDropdownFilter extends HookWidget {
  _CountryDropdownFilter({
    Key? key,
    required this.id,
    required this.selectableCountries,
  }) : super(key: key);

  final int id;
  final List<CountryModel> selectableCountries;

  @override
  Widget build(BuildContext context) {
    final filterType = useProvider(filterTypeScopedProvider);

    final usedCountries = useProvider(filterModelProvider(filterType)
        .select((value) => value.state.countries));

    final currentLocale = useProvider(currentLocaleProvider);

    final selectedValue = usedCountries.length <= id ? null : usedCountries[id];

    final items = selectedValue == null
        ? selectableCountries
        : (List<CountryModel>.from(selectableCountries)
          ..insert(
            lowerBound(
              selectableCountries,
              selectedValue,
              compare: (dynamic a, dynamic b) =>
                  SortingUtil.countryCompare(a, b, currentLocale),
            ),
            selectedValue,
          ));

    return useProvider(filterAggregationsProvider).when(
      data: (aggs) {
        return Row(
          children: [
            Expanded(
              child: DropdownButton<CountryModel>(
                value: selectedValue,
                isExpanded: true,
                hint: Text(id == 0
                    ? S.of(context).selectCountry
                    : S.of(context).addAnotherCountry),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.getName(currentLocale)!,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  context.read(filterModelProvider(filterType)).state = context
                      .read(filterModelProvider(filterType))
                      .state
                      .copyWith(
                        countries: usedCountries.followedBy([value!]).toList(),
                      );
                },
              ),
            ),
            if (selectedValue != null)
              IconButton(
                icon: Icon(Icons.cancel),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  final res = List<CountryModel>.from(context
                      .read(filterModelProvider(filterType))
                      .state
                      .countries)
                    ..removeAt(id);

                  context.read(filterModelProvider(filterType)).state = context
                      .read(filterModelProvider(filterType))
                      .state
                      .copyWith(
                        countries: res,
                      );
                },
              ),
          ],
        );
      },
      loading: () => const Loader(),
      error: (err, stack) {
        _logger.severe('Failed to fetch filter aggregations', err, stack);

        return Center(
          child: Text(S.of(context).error),
        );
      },
    );
  }
}
