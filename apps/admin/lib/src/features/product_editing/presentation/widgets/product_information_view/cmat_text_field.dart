import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/non_editable_text_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CmatTextField extends HookWidget {
  const CmatTextField({
    Key? key,
  }) : super(key: key);

  final String labelString = '* CMAT';

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.cmat,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: useProvider(isCreatingNewProductProvider)
          ? ActiveTextField(
              label: labelString,
              ctrl: textCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CMAT nemôže byť prázdne';
                }
                return null;
              },
              onSaved: (value) {
                context.read(editedProductProvider).state = context
                    .read(editedProductProvider)
                    .state
                    .copyWith(cmat: value ?? '');
              },
            )
          : NonEditableTextField(
              label: labelString,
              modifiedHint: 'Needitovateľné',
              ctrl: textCtrl,
            ),
    );
  }
}
