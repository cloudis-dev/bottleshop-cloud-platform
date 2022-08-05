import 'package:bottleshop_admin/src/features/login/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorText extends HookWidget {
  const ErrorText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMsg = useProvider(signInModelProvider).item2;

    if (errorMsg == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          '\u2022 $errorMsg',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
      );
    }
  }
}
