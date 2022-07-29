import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscardProductChangesDialog extends StatelessWidget {
  const DiscardProductChangesDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: const Text(
          'Zahodiť zmeny v produkte?',
          style: AppTheme.alertDialogContentTextStyle,
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Nie',
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read(navigationProvider.notifier).popPage();
            },
            child: Text(
              'Áno',
              style: AppTheme.buttonTextStyle
                  .copyWith(color: AppTheme.primaryColor),
            ),
          ),
        ],
      );
}
