import 'dart:ui';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AgeVerificationDialog extends HookConsumerWidget {
  const AgeVerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(context.l10n.ageValidationDialogTitle),
        content: Text(context.l10n.ageValidationDialogLabel),
        actions: [
          TextButton(
            onPressed: () => launch('about:blank', webOnlyWindowName: '_self'),
            child: Text(context.l10n.ageValidationDialogButtonNo),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(sharedPreferencesServiceProvider).setHasAgeVerified(verified: true);
              Navigator.of(context).pop();
            },
            child: Text(context.l10n.ageValidationDialogButtonYes),
          ),
        ],
      ),
    );
  }
}
