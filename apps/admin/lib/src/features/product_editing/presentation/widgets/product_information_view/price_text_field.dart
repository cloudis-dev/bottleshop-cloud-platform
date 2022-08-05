import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PriceTextField extends HookWidget {
  const PriceTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider)
          .state
          .finalPriceWithVat
          .toStringAsPrecision(4),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        label: '* Cena s DPH (bez zľavy)',
        ctrl: textCtrl,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        prefix: '€ ',
        onSaved: (value) {
          value = value?.replaceAll(',', '.');
          var res = double.tryParse(value ?? '') ?? 0;
          res = res / ProductModel.vatMultiplier;
          res = double.tryParse(res.toStringAsFixed(2)) ?? 0;

          context.read(editedProductProvider).state = context
              .read(editedProductProvider)
              .state
              .copyWith(priceNoVat: res);
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
    );
  }
}
