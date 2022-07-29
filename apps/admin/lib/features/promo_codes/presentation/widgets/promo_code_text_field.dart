import 'package:bottleshop_admin/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromoCodeTextField extends HookWidget {
  const PromoCodeTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(
          initialPromoCodeProvider.select((value) => value.state.code)),
    );

    return ActiveTextField(
      label: 'Promo kód',
      ctrl: textCtrl,
      onSaved: (value) {
        context.read(editedPromoCodeProvider).state =
            context.read(editedPromoCodeProvider).state.copyWith(code: value);
      },
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Názov promo kódu nemôže byť prázdny';
        }
        return null;
      },
    );
  }
}
