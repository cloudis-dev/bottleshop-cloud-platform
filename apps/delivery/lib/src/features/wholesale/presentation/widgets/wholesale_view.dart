import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:flutter/material.dart';

class WholeSaleView extends StatelessWidget {
  const WholeSaleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!shouldUseMobileLayout(context)) ...[
            Text(
              context.l10n.wholesale,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
          ],
          SelectableText(
            context.l10n.wholesaleDescription,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
