import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/ui/activities/intro_activity/intro_activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DevLoginButton extends HookWidget {
  const DevLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(signInModelProvider).item1;

    const authLogin = String.fromEnvironment('AUTH_LOGIN', defaultValue: '');
    const authPass = String.fromEnvironment('AUTH_PASS', defaultValue: '');

    if (authLogin.isEmpty || authPass.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.only(top: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppTheme.primaryColor,
            textStyle: TextStyle(color: Colors.white),
          ),
          onPressed: isLoading
              ? null
              : () async => context
                  .read(signInModelProvider.notifier)
                  .signIn(authLogin, authPass),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : Text('dev login'),
        ),
      );
    }
  }
}
