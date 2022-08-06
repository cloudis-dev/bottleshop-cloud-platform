import 'package:bottleshop_admin/src/core/data/models/country_model.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/active_dropdown_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CountryDropdown extends HookWidget {
  const CountryDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: ActiveDropdownField<CountryModel>(
        items: <DropdownMenuItem<CountryModel>>[
          ...context
              .read(constantAppDataProvider)
              .state
              .countries
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.localizedName.local,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
              .toList()
        ],
        validator: (val) {
          if (val == null) {
            return 'Musí byť vybraná krajina';
          }
          return null;
        },
        label: '* Krajina',
        onSaved: (value) {
          context.read(editedProductProvider).state = context
              .read(editedProductProvider)
              .state
              .copyWith(country: value);
        },
        currentValue: useProvider(
          editedProductProvider.select((value) => value.state.country),
        ),
      ),
    );
  }
}
