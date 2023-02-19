import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class DeleteAccountTile extends HookConsumerWidget {
  const DeleteAccountTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider) != null
        ? ListTile(
            dense: true,
            leading: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).errorColor,
            ),
            title: Text(
              context.l10n.deleteAccount,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              context.l10n.deleteAccountDetail,
              style: Theme.of(context).textTheme.caption,
            ),
            trailing: ButtonTheme(
              padding: const EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: TextButton(
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
                child: Text(context.l10n.delete),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return _DeleteConfirmationDialog(
                        parentContext: context,
                        parentRef: ref,
                      );
                    },
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _DeleteConfirmationDialog extends HookConsumerWidget {
  final BuildContext parentContext;
  final WidgetRef parentRef;

  const _DeleteConfirmationDialog({
    Key? key,
    required this.parentContext,
    required this.parentRef,
  }) : super(key: key);

  Future<void> _deleteAccount() async {
    bool result;

    try {
      result = await parentRef.read(cloudFunctionsProvider).deleteAccount();
    } catch (err) {
      result = false;
    }

    if (!result) {
      showSimpleNotification(
        const Text('Failed to delete account'),
        slideDismissDirection: DismissDirection.horizontal,
        context: parentContext,
      );
    } else {
      await parentRef.read(userRepositoryProvider).signOut();
      showSimpleNotification(
        const Text('Successfully deleted your account'),
        slideDismissDirection: DismissDirection.horizontal,
        context: parentContext,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleting = useState(false);

    return AlertDialog(
      title: Text(context.l10n.deleteAccountDialogTitle),
      content: Text(context.l10n.deleteAccountDialogLabel),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.deleteAccountNegativeOption),
        ),
        ElevatedButton(
          onPressed: () async {
            isDeleting.value = true;
            await _deleteAccount();
            Navigator.of(context).pop();
          },
          child: isDeleting.value
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(),
                )
              : Text(context.l10n.delete),
        ),
      ],
    );
  }
}
