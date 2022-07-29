import 'package:bottleshop_admin/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/active_text_field.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

class AlcoholTextField extends HookWidget {
  const AlcoholTextField({
    Key? key,
    required this.subtitleStyle,
  }) : super(key: key);

  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final alcohol = useProvider(initialProductProvider).state.alcohol;

    final textCtrl = useTextEditingController(
      text: alcohol == null
          ? null
          : FormattingUtil.getAlcoholNumberString(alcohol),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: useProvider(
                  editedProductProvider
                      .select((value) => value.state.hasAlcohol),
                ),
                onChanged: (value) {
                  final enabled = value ?? false;
                  context.read(editedProductProvider).state = context
                      .read(editedProductProvider)
                      .state
                      .copyWith(
                        alcohol: enabled ? Optional.of(0) : Optional.empty(),
                      );

                  textCtrl.text = enabled ? '0' : '';
                },
              ),
              Text(
                'Alkohol',
                style: subtitleStyle,
              )
            ],
          ),
          const SizedBox(height: 8),
          !useProvider(editedProductProvider
                  .select((value) => value.state.hasAlcohol))
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ActiveTextField(
                          label: 'Obsah alkoholu',
                          ctrl: textCtrl,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          suffix: '%',
                          onSaved: (value) {
                            value = value?.replaceAll(',', '.');
                            final res = double.tryParse(value ?? '') ?? 0;

                            context.read(editedProductProvider).state = context
                                .read(editedProductProvider)
                                .state
                                .copyWith(alcohol: Optional.of(res));
                          },
                          validator: (val) {
                            if (val != null &&
                                val.isNotEmpty &&
                                double.tryParse(val.replaceAll(',', '.')) ==
                                    null) {
                              return 'Alkohol musí byť číslo';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
