import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CountTextField extends HookWidget {
  const CountTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.count.toString(),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        label: '* Počet',
        ctrl: textCtrl,
        keyboardType: TextInputType.number,
        suffix: 'ks',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Počet nemôže byť prázdny';
          }

          if (double.tryParse(value) == null) {
            return 'Počet musí byť číslo';
          }

          return null;
        },
        onSaved: (value) {
          context.read(editedProductProvider).state = context
              .read(editedProductProvider)
              .state
              .copyWith(
                count: value == null || value.isEmpty ? 0 : int.tryParse(value),
              );
        },
      ),
    );
  }
}
