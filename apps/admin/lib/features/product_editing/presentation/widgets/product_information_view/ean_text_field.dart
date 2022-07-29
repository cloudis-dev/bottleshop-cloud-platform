import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EanTextField extends HookWidget {
  const EanTextField({
    Key? key,
  }) : super(key: key);

  final String labelString = '* EAN';

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.ean,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        label: labelString,
        ctrl: textCtrl,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'EAN nemôže byť prázdne';
          }
          return null;
        },
        onSaved: (value) {
          context.read(editedProductProvider).state = context
              .read(editedProductProvider)
              .state
              .copyWith(ean: value ?? '');
        },
      ),
    );
  }
}
