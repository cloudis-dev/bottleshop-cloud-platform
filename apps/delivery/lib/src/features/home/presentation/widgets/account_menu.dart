import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/menu_drawer.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/atoms/terms_and_conditions_text_content.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/sign_in_form.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/sign_up_form.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/terms_conditions_view.dart';
import 'package:delivery/src/features/opening_hours/presentation/dialogs/opening_hours_dialog.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_calendar.dart';

final _logger = Logger((AccountMenu).toString());

enum _TabsState {
  menu,
  termsAndConditions,
  login,
  signUp,
}

class AccountMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double width;
  final double maxHeight;

  const AccountMenu({
    Key? key,
    required this.scaffoldKey,
    required this.width,
    required this.maxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      width: width,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _MenuBody(scaffoldKey: scaffoldKey),
        ),
      ),
    );
  }
}

class _MenuBody extends HookWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _MenuBody({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabsState = useState(_TabsState.menu);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      child: () {
        switch (tabsState.value) {
          case _TabsState.menu:
            return _MenuItemsTab(
              scaffoldKey: scaffoldKey,
              onLogin: () {
                tabsState.value = _TabsState.termsAndConditions;
              },
            );
          case _TabsState.termsAndConditions:
            return _TermsAndConditionsTab(
              onBack: () {
                tabsState.value = _TabsState.menu;
              },
              onAccept: () {
                tabsState.value = _TabsState.login;
              },
            );
          case _TabsState.login:
            return _LoginTab(
              onBack: () {
                tabsState.value = _TabsState.menu;
              },
              onSignUp: () {
                tabsState.value = _TabsState.signUp;
              },
            );
          case _TabsState.signUp:
            return _SignUpTab(
              onBack: () {
                tabsState.value = _TabsState.login;
              },
            );
        }
      }(),
    );
  }
}

class _MenuItemsTab extends HookWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onLogin;

  const _MenuItemsTab({
    Key? key,
    required this.scaffoldKey,
    required this.onLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = useScrollController();
    final hasUser =
        useProvider(currentUserProvider.select((value) => value != null));

    return IntrinsicHeight(
      child: CupertinoScrollbar(
        controller: scrollCtrl,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollCtrl,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconTheme.of(context).copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!hasUser)
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(context.l10n.login),
                    onTap: onLogin,
                  ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: Text(context.l10n.favoriteTabLabel),
                  onTap: () {
                    context.read(navigationProvider).setNestingBranch(
                          scaffoldKey.currentContext!,
                          NestingBranch.favorites,
                        );

                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(context.l10n.settings),
                  onTap: () {
                    context.read(navigationProvider).setNestingBranch(
                          scaffoldKey.currentContext!,
                          NestingBranch.account,
                          branchParam: scaffoldKey.currentContext!
                              .read(navigationProvider)
                              .getNestingBranch(
                                scaffoldKey.currentContext!,
                              ),
                        );

                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                  },
                ),
                BottleshopAboutTile(
                  afterTap: () =>
                      OverlaySupportEntry.of(context)!.dismiss(animate: false),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outlined),
                  title: Text(context.l10n.helpSupport),
                  onTap: () {
                    context.read(navigationProvider).setNestingBranch(
                          scaffoldKey.currentContext!,
                          NestingBranch.help,
                          branchParam: scaffoldKey.currentContext!
                              .read(navigationProvider)
                              .getNestingBranch(
                                scaffoldKey.currentContext!,
                              ),
                        );

                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.gavel),
                  title: Text(context.l10n.menuTerms),
                  onTap: () {
                    context.read(navigationProvider).pushPage(
                          context,
                          AppPageNode(page: TermsConditionsPage()),
                          toParent: true,
                        );
                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                  },
                ),
                if (hasUser)
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: Text(context.l10n.logOut),
                    onTap: () async {
                      await context.read(userRepositoryProvider).signOut();
                      OverlaySupportEntry.of(context)!.dismiss(animate: false);
                    },
                  ),
                ListTile(
                  title: const OpeningHoursCalendar(),
                  onTap: () {
                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                    showDialog<void>(
                      context: context,
                      builder: (context) => const OpeningHoursDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditionsTab extends HookWidget {
  final VoidCallback onAccept;
  final VoidCallback onBack;

  const _TermsAndConditionsTab({
    Key? key,
    required this.onAccept,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = useScrollController();

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBack,
            ),
          ),
          Expanded(
            child: CupertinoScrollbar(
              thumbVisibility: true,
              controller: scrollCtrl,
              child: SingleChildScrollView(
                controller: scrollCtrl,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.termsTitleMainScreen,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 20),
                      TermsAndConditionsTextContent(
                        onNavigateToTermsPage: () {
                          context.read(navigationProvider).pushPage(
                                context,
                                AppPageNode(page: TermsConditionsPage()),
                              );

                          OverlaySupportEntry.of(context)!
                              .dismiss(animate: false);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: onAccept,
            textStyle: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            child: Text(context.l10n.termsPopUpYes),
          ),
          CupertinoDialogAction(
            onPressed: onBack,
            isDefaultAction: true,
            textStyle: Theme.of(context).textTheme.subtitle2,
            child: Text(context.l10n.termsPopUpNo),
          ),
        ],
      ),
    );
  }
}

class _SignUpTab extends HookWidget {
  final VoidCallback onBack;

  const _SignUpTab({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = useScrollController();

    return IntrinsicHeight(
      child: CupertinoScrollbar(
        thumbVisibility: true,
        controller: scrollCtrl,
        child: SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: onBack,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SignUpForm(
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  authCallback: (val) =>
                      _logger.info('Sign up callback status: $val'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginTab extends HookWidget {
  final VoidCallback onBack;
  final VoidCallback onSignUp;

  const _LoginTab({
    Key? key,
    required this.onBack,
    required this.onSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = useScrollController();

    return IntrinsicHeight(
      child: CupertinoScrollbar(
        thumbVisibility: true,
        controller: scrollCtrl,
        child: SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: onBack,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SignInForm(
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  authCallback: (val) => debugPrint(val.toString()),
                ),
              ),
              TextButton(
                onPressed: onSignUp,
                child: Text(context.l10n.dontHaveAnAccount),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
