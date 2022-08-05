import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/ui/intro_activity/intro_activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInButton extends HookWidget {
  const SignInButton({
    Key? key,
    required this.emailCtrl,
    required this.passwordCtrl,
  }) : super(key: key);

  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(signInModelProvider).item1;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppTheme.primaryColor,
          textStyle: TextStyle(color: Colors.white),
        ),
        onPressed: isLoading
            ? null
            : () => context
                .read(signInModelProvider.notifier)
                .signIn(emailCtrl.text, passwordCtrl.text),
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
            : Text('Prihlásiť sa'),
      ),
    );
  }
}
