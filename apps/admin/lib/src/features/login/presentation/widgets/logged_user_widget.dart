import 'package:bottleshop_admin/src/core/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoggedUserWidget extends HookWidget {
  const LoggedUserWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loggedUser = useProvider(loggedUserProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Prihlásený používateľ',
          style: TextStyle(fontSize: 15, color: Colors.white54),
        ),
        if (loggedUser.state != null)
          Text(
            '@${loggedUser.state!.nick}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white70),
          ),
      ],
    );
  }
}
