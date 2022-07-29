import 'package:bottleshop_admin/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/models/promo_code_model.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:bottleshop_admin/utils/math_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromoDiscountTextField extends HookWidget {
  const PromoDiscountTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(
        initialPromoCodeProvider
            .select((value) => value.state.discountValue.toString()),
      ),
    );

    return ActiveTextField(
      label: 'Hodnotová zľava',
      ctrl: textCtrl,
      keyboardType: TextInputType.number,
      suffix: '€',
      onSaved: (value) {
        value = value?.replaceAll(',', '.');
        var res = double.tryParse(value ?? '') ?? 0;
        res = double.tryParse(res.toStringAsFixed(2)) ?? 0;

        context.read(editedPromoCodeProvider).state =
            context.read(editedPromoCodeProvider).state.copyWith(
                  discountValue: res,
                  promoCodeType: PromoCodeType.value,
                );
      },
      validator: (val) {
        final parsed = double.tryParse(val?.replaceAll(',', '.') ?? '');
        if (parsed == null) {
          return 'Musí byť číslo';
        }

        if (MathUtil.approximately(parsed, 0) || parsed < 0) {
          return 'Musí byť väčšie ako 0';
        }
      },
    );
  }
}
