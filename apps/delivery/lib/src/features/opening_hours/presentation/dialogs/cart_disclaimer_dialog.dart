import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';

void showCartDisclaimer(BuildContext context) async {
  final closingSoon = await OpeningHoursModel.closingSoon(context);

  if (closingSoon) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              elevation: 10,
              title: Text(context.l10n.cartDisclaimerHead),
              content: Text(context.l10n.cartDisclaimerBody),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read(cartDisclaimerProvider).state = true;

                      Navigator.of(context).pop();
                    },
                    child: Text(context.l10n.cartDisclaimerButton),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
    );
  }
}
