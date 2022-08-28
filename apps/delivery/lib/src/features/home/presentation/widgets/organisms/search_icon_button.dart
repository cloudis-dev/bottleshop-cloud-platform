import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchIconButton extends StatelessWidget {
  const SearchIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).searchFieldLabel,
      icon: const Icon(Icons.search),
      onPressed: () => context.read(navigationProvider).setNestingBranch(
            context,
            NestingBranch.search,
            resetBranchStack: true,
            branchParam:
                context.read(navigationProvider).getNestingBranch(context),
          ),
    );
  }
}
