import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:bottleshop_admin/utils/math_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnitsCountTextField extends HookWidget {
  const UnitsCountTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.unitsCount.toString(),
    );

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: ActiveTextField(
          label: '* Počet jednotiek',
          ctrl: textCtrl,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          suffix: useProvider(editedProductProvider.select(
              (value) => value.state.unitsType))?.localizedAbbreviation.local,
          onSaved: (value) {
            value = value?.replaceAll(',', '.');
            final res = double.tryParse(value ?? '') ?? 0;

            context.read(editedProductProvider).state = context
                .read(editedProductProvider)
                .state
                .copyWith(unitsCount: res);
          },
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Nemôže byť prázdne';
            }
            final parsed = double.tryParse(val.replaceAll(',', '.'));
            if (parsed == null) {
              return 'Musí byť číslo';
            }

            if (MathUtil.approximately(parsed, 0) || parsed < 0) {
              return 'Musí byť väčšie ako 0';
            }

            return null;
          },
        ),
      ),
    );
  }
}
