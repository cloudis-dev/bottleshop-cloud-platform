import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsagesCountTextField extends HookWidget {
  const UsagesCountTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(
        initialPromoCodeProvider
            .select((value) => value.state.remainingUsesCount),
      ).toString(),
    );

    return ActiveTextField(
      label: 'Počet použití',
      ctrl: textCtrl,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        context.read(editedPromoCodeProvider).state = context
            .read(editedPromoCodeProvider)
            .state
            .copyWith(remainingUsesCount: int.tryParse(value ?? '0'));
      },
      validator: (val) {
        final parsed = int.tryParse(val?.replaceAll(',', '.') ?? '');
        if (parsed == null) {
          return 'Musí byť číslo';
        }

        if (parsed < 0) {
          return 'Musí byť väčšie alebo rovné 0';
        }

        return null;
      },
    );
  }
}
