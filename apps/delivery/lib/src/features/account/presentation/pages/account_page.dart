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

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/dropdown.dart';
import 'package:delivery/src/core/presentation/widgets/profile_avatar.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/account/presentation/widgets/account_card.dart';
import 'package:delivery/src/features/account/presentation/widgets/delete_account_tile.dart';
import 'package:delivery/src/features/account/presentation/widgets/dropdown_list_item.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/organisms/language_dropdown.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class AccountPage extends RoutebornPage {
  static const String pagePathBase = 'account';

  AccountPage() : super.builder(pagePathBase, (_) => const _AccountPageView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.settings);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _AccountPageView extends HookConsumerWidget {
  const _AccountPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final scrollCtrl = useScrollController();

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(context.l10n.settings),
          leading: CloseButton(
            color: kPrimaryColor,
            onPressed: () {
              ref.read(navigationProvider).setNestingBranch(
                    context,
                    RoutebornBranchParams.of(context).getBranchParam()
                            as NestingBranch? ??
                        NestingBranch.shop,
                  );
            },
          ),
        ),
        body: CupertinoScrollbar(
          controller: scrollCtrl,
          child: _Body(scrollCtrl: scrollCtrl),
        ),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        body: Scrollbar(
          controller: scrollCtrl,
          child: PageBodyTemplate(
            child: _Body(scrollCtrl: scrollCtrl),
          ),
        ),
      );
    }
  }
}

class _Body extends HookConsumerWidget {
  final ScrollController scrollCtrl;

  const _Body({Key? key, required this.scrollCtrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    final themeWidgets = <DropdownListItem>[
      DropdownListItem(label: context.l10n.system),
      DropdownListItem(label: context.l10n.light),
      DropdownListItem(label: context.l10n.dark),
    ];

    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user?.name ?? context.l10n.anonymousUser,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        user?.email ?? context.l10n.na,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(300),
                    child: ProfileAvatar(imageUrl: user?.avatar),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                const AccountCard(),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 5)
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      if (shouldUseMobileLayout(context)) ...[
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: Text(
                            context.l10n.preferences,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: Text(
                            context.l10n.languages,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: const LanguageDropdown(),
                        ),
                        if (!kIsWeb)
                          ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.settings_display_rounded,
                            ),
                            title: Text(
                              context.l10n.darkMode,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: DropDown<ThemeMode>(
                              items: ThemeMode.values,
                              showUnderline: false,
                              initialValue: ref
                                  .read(sharedPreferencesProvider)
                                  .getThemeMode(),
                              customWidgets: themeWidgets,
                              onChanged: (value) async {
                                await ref
                                    .read(sharedPreferencesProvider)
                                    .setThemeMode(value!);
                                ref.refresh(sharedPreferencesProvider);
                              },
                            ),
                          ),
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const DeleteAccountTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
