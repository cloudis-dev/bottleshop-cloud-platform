import 'package:bottleshop_admin/src/core/presentation/widgets/active_text_field.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class EditionTextField extends HookWidget {
  const EditionTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.edition,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        ctrl: textCtrl,
        onSaved: (value) {
          context.read(editedProductProvider).state =
              context.read(editedProductProvider).state.copyWith(
                    edition: value == null || value.isEmpty
                        ? Optional.empty()
                        : Optional.of(value),
                  );
        },
        label: 'Edícia',
      ),
    );
  }
}
