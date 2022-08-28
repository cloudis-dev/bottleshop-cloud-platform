// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/profile_avatar.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideMenuHeader extends HookWidget {
  const SideMenuHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = useProvider(currentUserProvider);

    return GestureDetector(
      onTap: () {
        context.read(navigationProvider).setNestingBranch(
              context,
              NestingBranch.account,
              inChildNavigator: true,
            );
      },
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius:
              const BorderRadius.only(bottomLeft: Radius.circular(35)),
        ),
        accountName: Text(
          userData?.name ?? context.l10n.anonymousUser,
          style: Theme.of(context).textTheme.headline6,
        ),
        accountEmail: Text(
          userData?.email ?? context.l10n.anonymousUser,
          style: Theme.of(context).textTheme.caption,
        ),
        currentAccountPicture: ProfileAvatar(imageUrl: userData?.avatar),
      ),
    );
  }
}
