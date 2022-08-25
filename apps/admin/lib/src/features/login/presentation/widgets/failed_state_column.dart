import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/login/presentation/pages/intro_activity.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FailedStateColumn extends StatelessWidget {
  const FailedStateColumn(
    this._onPagesAfterLogin, {
    Key? key,
  }) : super(key: key);

  final List<AppPage> Function() _onPagesAfterLogin;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Niekde nastal problém!\nSkontrolujte pripojenie na internet s skúste znova.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextButton(
                    onPressed: () => context
                        .read(navigationProvider.notifier)
                        .replaceAllWith(
                      [
                        IntroActivityPage(onPagesAfterLogin: _onPagesAfterLogin)
                      ],
                    ),
                    child: Text('Skús znova'),
                  ),
                )
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      );
}
