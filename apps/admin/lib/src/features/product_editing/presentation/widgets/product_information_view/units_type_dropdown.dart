import 'package:bottleshop_admin/src/core/data/models/unit_model.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/active_dropdown_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnitsTypeDropdown extends HookWidget {
  const UnitsTypeDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        child: ActiveDropdownField<UnitModel>(
          label: '* Jednotky',
          currentValue: useProvider(
            editedProductProvider.select((value) => value.state.unitsType),
          ),
          items: <DropdownMenuItem<UnitModel>>[
            ...context.read(constantAppDataProvider).state.units.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.localizedUnit.local,
                        style: const TextStyle(color: Colors.black)),
                  ),
                )
          ],
          onSaved: (value) {
            context.read(editedProductProvider).state = context
                .read(editedProductProvider)
                .state
                .copyWith(unitsType: value);
          },
          validator: (val) {
            if (val == null) {
              return 'Musí byť vybraná jednotka';
            }
            return null;
          },
        ),
      ),
    );
  }
}
