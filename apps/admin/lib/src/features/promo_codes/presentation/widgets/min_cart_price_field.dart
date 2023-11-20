import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MinCartPriceField extends HookWidget {
  const MinCartPriceField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(
        initialPromoCodeProvider
            .select((value) => value.state.minCartValue.toString()),
      ),
    );

    return ActiveTextField(
      label: 'Minimálna cena v košíku',
      ctrl: textCtrl,
      keyboardType: TextInputType.number,
      suffix: '€',
      onSaved: (value) {
        value = value?.replaceAll(',', '.');
        var res = double.tryParse(value ?? '') ?? 0;
        res = double.tryParse(res.toStringAsFixed(2)) ?? 0;

        context.read(editedPromoCodeProvider).state = context
            .read(editedPromoCodeProvider)
            .state
            .copyWith(minCartValue: res);
      },
      validator: (val) {
        final parsed = double.tryParse(val?.replaceAll(',', '.') ?? '');
        if (parsed! < 0) {
          return 'Musí byť väčšie alebo rovné 0';
        } else {
          return 'Musí byť číslo';
        }
      },
    );
  }
}
