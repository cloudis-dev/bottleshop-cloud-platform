import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NameTextField extends HookWidget {
  const NameTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.name,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        ctrl: textCtrl,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Názov produktu nemôže byť prázdny';
          }
          if (value[0].toUpperCase() != value[0]) {
            return 'Začiatočné písmeno musí byť veľké';
          }
          return null;
        },
        onSaved: (value) {
          context.read(editedProductProvider).state =
              context.read(editedProductProvider).state.copyWith(name: value);
        },
        label: '* Názov',
      ),
    );
  }
}
