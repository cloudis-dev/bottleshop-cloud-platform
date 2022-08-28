import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/features/auth/presentation/dialogs/terms_and_conditions_dialog.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TermsAndConditionsTile extends HookWidget {
  const TermsAndConditionsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isChecked = useProvider(termsAcceptanceProvider);
    return IntrinsicWidth(
      child: CheckboxListTile(
        activeColor: Theme.of(context).primaryColor,
        checkColor: Theme.of(context).colorScheme.secondary,
        selected: isChecked,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) async {
          if (newValue == true) {
            if (await showDialog<bool>(
                  context: context,
                  builder: (context) => TermsAndConditionsDialog(),
                ) ==
                true) {
              context.read(termsAcceptanceProvider.notifier).acceptTerms();
            } else {
              context.read(termsAcceptanceProvider.notifier).rejectTerms();
            }
          } else {
            context.read(termsAcceptanceProvider.notifier).rejectTerms();
          }
        },
        value: isChecked,
        title: Text(
          S.of(context).termsTitleMainScreen,
          textAlign: TextAlign.left,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
