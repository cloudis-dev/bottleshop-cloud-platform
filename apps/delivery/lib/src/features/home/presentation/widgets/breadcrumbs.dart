import 'package:delivery/src/config/app_theme.dart';
import 'package:delivery/src/core/utils/iterable_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Breadcrumbs extends HookConsumerWidget {
  const Breadcrumbs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = [];

    return pages.length <= 1
        ? const SizedBox.shrink()
        : Container(
            color: Theme.of(context).focusColor,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 4),
            child: Row(
              children: [
                ...pages
                    .map<Widget>(
                      (e) => TextButtonTheme(
                        data: textButtonLinkTheme,
                        child: TextButton(
                          child: e.page.getPageName(context.l10n.fold(
                                (l) => ValueListenableBuilder<String?>(
                                  valueListenable: l,
                                  builder: (context, value, _) {
                                    if (value != null) {
                                      return Text(value);
                                    }
                                    return const SizedBox(
                                      height: 12,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(strokeWidth: 2.5),
                                      ),
                                    );
                                  },
                                ),
                                (r) => Text(r),
                              ),
                          onPressed: () {},
                        ),
                      ),
                    )
                    .interleave(
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('•'),
                      ),
                    )
                    .toList()
              ],
            ),
          );
  }
}
