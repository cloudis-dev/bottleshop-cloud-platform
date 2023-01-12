import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger((CheckoutViewTemplate).toString());

class CheckoutViewTemplate extends HookConsumerWidget {
  final String pageTitle;
  final String actionButtonText;
  final VoidCallback onBackButton;
  final Widget Function(UserModel?) contentBuilder;
  final Future<void> Function()? Function(UserModel?) actionCallback;

  const CheckoutViewTemplate({
    Key? key,
    required this.contentBuilder,
    required this.pageTitle,
    required this.onBackButton,
    required this.actionButtonText,
    required this.actionCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        leading: BackButton(onPressed: onBackButton),
      ),
      body: ref.watch(currentUserAsStream).when(
            data: (user) {
              return Column(
                // fit: StackFit.expand,
                children: <Widget>[
                  Expanded(
                    child: contentBuilder(user),
                  ),
                  CheckoutTile(
                    actionLabel: actionButtonText,
                    actionCallback: actionCallback(user),
                  ),
                ],
              );
            },
            loading: () => const Loader(),
            error: (err, stack) {
              _logger.severe('Failed to stream current user', err, stack);
              return Center(
                child: Text(context.l10n.error),
              );
            },
          ),
    );
  }
}
