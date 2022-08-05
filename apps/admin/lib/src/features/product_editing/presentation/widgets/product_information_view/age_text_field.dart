import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/non_editable_text_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class AgeTextField extends HookWidget {
  const AgeTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.age?.toString(),
    );

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: useProvider(editedProductProvider
                .select((value) => value.state.year == null))
            ? ActiveTextField(
                ctrl: textCtrl,
                onSaved: (value) {
                  context.read(editedProductProvider).state =
                      context.read(editedProductProvider).state.copyWith(
                            age: value == null || value.isEmpty
                                ? Optional.empty()
                                : Optional.of(int.tryParse(value)),
                          );
                },
                validator: (val) {
                  if (val != null &&
                      val.isNotEmpty &&
                      int.tryParse(val) == null) {
                    return 'Vek musí byť číslo';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                label: 'Vek',
                suffix: 'rokov',
              )
            : NonEditableTextField(
                label: 'Vek',
                modifiedHint: 'Buď vek alebo rok',
                ctrl: null,
              ),
      ),
    );
  }
}
