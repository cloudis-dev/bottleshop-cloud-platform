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
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/account/presentation/widgets/address_settings_dialog.dart';
import 'package:delivery/src/features/account/presentation/widgets/profile_settings_dialog.dart';
import 'package:delivery/src/features/auth/data/models/address_model.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountCard extends HookConsumerWidget {
  const AccountCard({
    Key? key,
    this.showBirthday = true,
  }) : super(key: key);
  final bool showBirthday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(currentLanguageProvider);
    return ref.watch(currentUserAsStream).when(
          data: (user) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  )
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.supervised_user_circle_outlined),
                    title: Text(
                      context.l10n.contactDetails,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: const Text(''),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.email_outlined),
                    title: Text(
                      context.l10n.email,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      user?.email ?? context.l10n.anonymousUser,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    trailing: ButtonTheme(
                      padding: const EdgeInsets.all(0),
                      minWidth: 50.0,
                      height: 25.0,
                      child: ProfileSettingsDialog(
                        showBirthday: showBirthday,
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.person_outline_rounded,
                    ),
                    title: Text(
                      context.l10n.fullName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      user?.name ?? context.l10n.anonymousUser,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.settings_phone,
                    ),
                    title: Text(
                      context.l10n.phoneNumber,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      user?.phoneNumber ?? context.l10n.notSet,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  if (showBirthday)
                    ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.calendar_today,
                      ),
                      title: Text(
                        context.l10n.birthDate,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      subtitle: Text(
                        user?.dayOfBirth != null
                            ? FormattingUtils.getDateFormatter(currentLang)
                                .format(user!.dayOfBirth!)
                            : context.l10n.tellUsYourBirthdayToGetASpecialGift,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    thickness: 0.5,
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.business_outlined,
                    ),
                    title: Text(
                      context.l10n.billingAddress,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      user?.billingAddress?.getAddressAsString() ??
                          context.l10n.notSet,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    trailing: ButtonTheme(
                      padding: const EdgeInsets.all(0),
                      minWidth: 50.0,
                      height: 25.0,
                      child: AddressSettingsDialog(
                          title: context.l10n.billingAddress),
                    ),
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    thickness: 0.5,
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.home_outlined,
                    ),
                    title: Text(
                      context.l10n.shippingAddress,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      user?.shippingAddress?.getAddressAsString() ??
                          context.l10n.notSet,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    trailing: ButtonTheme(
                      padding: const EdgeInsets.all(0),
                      minWidth: 50.0,
                      height: 25.0,
                      child: AddressSettingsDialog(
                        addressType: AddressType.shipping,
                        title: context.l10n.shippingAddress,
                        icon: const Icon(Icons.home_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Loader(),
          error: (err, _) => const Center(
            child: Text('error'),
          ),
        );
  }
}
