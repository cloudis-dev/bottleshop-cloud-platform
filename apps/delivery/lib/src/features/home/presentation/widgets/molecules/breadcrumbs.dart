import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/utils/iterable_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Breadcrumbs extends HookConsumerWidget {
  const Breadcrumbs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref
        .watch(navigationProvider
            .select((value) => value.getNavigationStack(context)))
        .pageNodesStack;

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
                          child: e.page.getPageName(context).fold(
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
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5),
                                      ),
                                    );
                                  },
                                ),
                                (r) => Text(r),
                              ),
                          onPressed: () {
                            ref.read(navigationProvider).popUntil(
                                  context,
                                  (page) =>
                                      page.runtimeType == e.page.runtimeType,
                                );
                          },
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
