import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class DescriptionEnTextField extends HookWidget {
  const DescriptionEnTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = useTextEditingController(
      text: useProvider(initialProductProvider).state.descriptionEn,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: ActiveTextField(
        label: 'Popis EN',
        ctrl: textCtrl,
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: 10,
        onSaved: (value) {
          context.read(editedProductProvider).state =
              context.read(editedProductProvider).state.copyWith(
                    descriptionEn: value == null || value.isEmpty
                        ? Optional.empty()
                        : Optional.of(value),
                  );
        },
      ),
    );
  }
}
