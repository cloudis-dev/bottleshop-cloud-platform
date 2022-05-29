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

import 'package:delivery/src/core/utils/iterable_extension.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:delivery/src/features/sticky_header/presentation/providers/providers.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/age_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/alcohol_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/countries_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/extra_categories_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/is_special_edition_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/price_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/quantity_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/volume_filter_chip.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/filter_chips/year_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FiltersStickyHeader extends HookConsumerWidget {
  const FiltersStickyHeader({
    Key? key,
    required this.filterType,
  }) : super(key: key);

  final FilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(appliedFilterProvider(filterType).state).state;

    return SizedBox(
      height: 52,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            clipBehavior: Clip.hardEdge,
            width: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: Material(
              color: Theme.of(context).colorScheme.secondary.withOpacity(1),
              child: Ink(
                child: IconButton(
                  onPressed: () {
                    ref.read(appliedFilterProvider(filterType.state) = FilterModel.empty();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
              ),
              child: ProviderScope(
                overrides: [
                  alcoholRangeScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.alcoholRange,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedAlcoholFilter();
                      },
                    ),
                  ),
                  quantityScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.minQuantity,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedQuantityFilter();
                      },
                    ),
                  ),
                  volumeRangeScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.volumeRange,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedVolumeFilter();
                      },
                    ),
                  ),
                  priceRangeScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.priceRange,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedPriceFilter();
                      },
                    ),
                  ),
                  isSpecialEditionScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.isSpecialEdition,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedSpecialEditionFilter();
                      },
                    ),
                  ),
                  countriesScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.countries,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedCountriesFilter();
                      },
                    ),
                  ),
                  minAgeScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.minAge,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedAgeFilter();
                      },
                    ),
                  ),
                  maxYearScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.maxYear,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedYearFilter();
                      },
                    ),
                  ),
                  extraCategoriesScopedProvider.overrideWithValue(
                    FilterValue(
                      value: filter.enabledExtraCategoriesIds,
                      onDeleteFilter: () {
                        final val = ref.read(appliedFilterProvider(filterTypel10n.state);
                        val.state = val.state.clearedExtraCategoriesFilter();
                      },
                    ),
                  ),
                ],
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    if (filter.isAlcoholActive) const AlcoholFilterChip(),
                    if (filter.isQuantityActive) const QuantityFilterChip(),
                    if (filter.isVolumeActive) const VolumeFilterChip(),
                    if (filter.isPriceActive) const PriceFilterChip(),
                    if (filter.isSpecialEditionActive) const IsSpecialEditionFilterChip(),
                    if (filter.isCountriesActive) const CountriesFilterChip(),
                    if (filter.isAgeActive) const AgeFilterChip(),
                    if (filter.isYearActive) const YearFilterChip(),
                    if (filter.isExtraCategoriesActive) const ExtraCategoriesFilterChip(),
                  ].interleave(const SizedBox(width: 10)l10n.toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
