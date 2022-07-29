import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/non_editable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PriceNoVatReadonlyField extends HookWidget {
  const PriceNoVatReadonlyField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: NonEditableTextField(
        label: '* Cena bez DPH',
        modifiedHint: 'Needitovateľné',
        ctrl: TextEditingController(
          text: useProvider(editedProductProvider
              .select((value) => value.state.priceNoVat)).toStringAsFixed(4),
        ),
        prefix: '€ ',
      ),
    );
  }
}
