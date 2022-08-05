import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscardPromoCodeChangesDialog extends StatelessWidget {
  const DiscardPromoCodeChangesDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: const Text(
          'Zahodiť zmeny v promo kóde?',
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
