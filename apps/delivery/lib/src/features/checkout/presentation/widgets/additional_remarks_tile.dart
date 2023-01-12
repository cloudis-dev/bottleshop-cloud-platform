import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdditionalRemarksTile extends ConsumerWidget {
  const AdditionalRemarksTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textCtrl = ref.watch(remarksTextEditCtrlProvider);

    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(
          Icons.notes_outlined,
        ),
        title: Text(
          context.l10n.additionalRemarks,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          context.l10n.instructionsForDelivery,
          style: Theme.of(context).textTheme.caption,
        ),
        children: [
          ListTile(
            title: TextField(
              controller: textCtrl,
              minLines: 1,
              maxLines: 4,
            ),
          )
        ],
      ),
    );
  }
}
