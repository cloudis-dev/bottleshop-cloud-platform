import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchIconButton extends HookConsumerWidget {
  const SearchIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        tooltip: MaterialLocalizations.of(context).searchFieldLabel,
        icon: const Icon(Icons.search),
        onPressed: null);
  }
}
