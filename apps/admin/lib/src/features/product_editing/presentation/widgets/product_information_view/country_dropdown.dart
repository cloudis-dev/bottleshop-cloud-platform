import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/config/app_theme.dart';

class CountryDropdown extends HookWidget {
  const CountryDropdown({
    Key? key,
  }) : super(key: key);

  bool searchFunction(String item, String filter) {
    item = item.toLowerCase();
    filter = filter.toLowerCase();
    item = item.replaceAll('ä', 'a');
    item = item.replaceAll('á', 'a');
    item = item.replaceAll('č', 'c');
    item = item.replaceAll('ď', 'd');
    item = item.replaceAll('é', 'e');
    item = item.replaceAll('í', 'i');
    item = item.replaceAll('ĺ', 'l');
    item = item.replaceAll('ľ', 'l');
    item = item.replaceAll('ň', 'n');
    item = item.replaceAll('ó', 'o');
    item = item.replaceAll('ô', 'o');
    item = item.replaceAll('ŕ', 'r');
    item = item.replaceAll('š', 's');
    item = item.replaceAll('ť', 't');
    item = item.replaceAll('ú', 'u');
    item = item.replaceAll('ý', 'y');
    item = item.replaceAll('ž', 'z');
    return item.contains(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: DropdownSearch<String>(
        filterFn: searchFunction,
        popupProps:
            PopupProps.menu(showSelectedItems: true, showSearchBox: true),
        items: useProvider(constantAppDataProvider)
            .state
            .countries
            .map((e) => e.localizedName.local)
            .toList(),
        validator: (val) {
          if (val == null) {
            return 'Musí byť vybraná krajina';
          }
          return null;
        },
        selectedItem: useProvider(
          editedProductProvider.select((value) => value.state.country?.localizedName.local),
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            hintText: '* Krajina',
            filled: true,
            fillColor: AppTheme.lightGreySolid,
          )
        ),
        onChanged: (value) {
          context.read(editedProductProvider).state = context
              .read(editedProductProvider)
              .state
              .copyWith(
                  country: context
                      .read(constantAppDataProvider)
                      .state
                      .countries
                      .firstWhere(
                          (element) => element.localizedName.local == value));
        },
      ),
    );
  }
}
