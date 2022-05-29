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
import 'package:delivery/src/core/presentation/widgets/drawer_state_acquirer.dart';
import 'package:delivery/src/config/app_config.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/widgets/age_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/age_year_filter_toggle.dart';
import 'package:delivery/src/features/filter/presentation/widgets/alcohol_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/country_dropdowns_group.dart';
import 'package:delivery/src/features/filter/presentation/widgets/extra_category_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/filter_drawer_footer.dart';
import 'package:delivery/src/features/filter/presentation/widgets/filter_drawer_header.dart';
import 'package:delivery/src/features/filter/presentation/widgets/is_special_edition_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/price_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/quantity_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/volume_filter.dart';
import 'package:delivery/src/features/filter/presentation/widgets/year_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final filterTypeScopedProvider = Provider<FilterType>((ref) => FilterType.allProducts);

class FilterDrawer extends HookConsumerWidget {
  final GlobalKey<DrawerStateAcquirerState> drawerAcquirerKey;

  const FilterDrawer({
    Key? key,
    required this.filterType,
    required this.drawerAcquirerKey,
  }) : super(key: key);

  final FilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final algoliaImage = AppConfig(context.l10n.platformBrightness() == Brightness.light ? kAlgoliaLogo : kAlgoliaLogoDark;

    return SizedBox(
      width: 350,
      child: Drawer(
        child: DrawerStateAcquirer(
          key: drawerAcquirerKey,
          child: SafeArea(
            child: ProviderScope(
              overrides: [
                filterTypeScopedProvider.overrideWithValue(filterType),
              ],
              child: Column(
                children: <Widget>[
                  const FilterDrawerHeader(),
                  const Divider(),
                  Expanded(
                    child: CupertinoScrollbar(
                      isAlwaysShown: true,
                      controller: scrollController,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        primary: false,
                        children: <Widget>[
                          const AlcoholFilter(),
                          const QuantityFilter(),
                          const VolumeFilter(),
                          const PriceFilter(),
                          const Divider(),
                          const IsSpecialEditionFilter(),
                          const Divider(),
                          const ExtraCategoriesGroupFilter(),
                          const Divider(),
                          const CountryDropdownsFilterGroup(),
                          const Divider(),
                          const AgeYearFilterToggle(),
                          const AgeFilter(),
                          const YearFilter(),
                          const SizedBox(height: 10),
                          Image.asset(
                            algoliaImage,
                            height: 15,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const FilterDrawerFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
