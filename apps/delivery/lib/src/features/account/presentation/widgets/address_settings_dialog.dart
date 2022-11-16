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
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/presentation/widgets/styled_form_field.dart';
import 'package:delivery/src/features/account/presentation/widgets/checkbox_list_tile_formfield.dart';
import 'package:delivery/src/features/auth/data/models/address_model.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/data/services/user_db_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';

final _logger = Logger((AddressSettingsDialog).toString());

class AddressSettingsDialog extends HookConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String title;
  final Icon icon;
  final AddressType addressType;

  AddressSettingsDialog({
    Key? key,
    this.addressType = AddressType.billing,
    required this.title,
    this.icon = const Icon(Icons.business_outlined),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    return ref.watch(currentUserAsStream).when(
          data: (user) {
            var profileData = <String, dynamic>{};
            return TextButton(
              onPressed: user == null
                  ? null
                  : () async {
                      await showAddressDialog(
                        context: context,
                        controller: scrollController,
                        user: user,
                        profileData: profileData,
                      );
                    },
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary),
              child: Text(
                context.l10n.edit,
              ),
            );
          },
          loading: () => const Loader(),
          error: (err, stack) {
            _logger.severe('Failed to stream current user', err, stack);
            return Center(
              child: Text(context.l10n.error),
            );
          },
        );
  }

  Future<void> showAddressDialog({
    required BuildContext context,
    required ScrollController controller,
    required UserModel user,
    required Map<String, dynamic> profileData,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: buildDialogTitle(context),
          content: CupertinoScrollbar(
            controller: controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              child: buildAddressForm(
                context: context,
                user: user,
                profileData: profileData,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                var isValid = _formKey.currentState!.validate();
                _logger.fine('form valid: $isValid');
                if (isValid) {
                  _formKey.currentState!.save();
                  _logger.fine(
                      'data: ${profileData['city']}, ${profileData['phoneNumber']} billingOnly: ${profileData['billingOnly']}');
                  var userData = <String, dynamic>{};
                  if (addressType == AddressType.billing) {
                    if (profileData['billingOnly'] ?? false) {
                      profileData.remove('billingOnly');
                      userData['shipping_address'] = profileData;
                    }
                    userData['billing_address'] = profileData;
                  } else {
                    userData['shipping_address'] = profileData;
                  }
                  userDb.updateData(user.uid, userData);
                  showSimpleNotification(
                    Text(context.l10n.profileUpdatedMsg),
                    position: NotificationPosition.bottom,
                    slideDismissDirection: DismissDirection.horizontal,
                    context: context,
                  );
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary),
              child: Text(context.l10n.saveButton),
            ),
          ],
        );
      },
    );
  }

  Form buildAddressForm({
    required BuildContext context,
    required UserModel user,
    required Map<String, dynamic> profileData,
  }) {
    final address = addressType == AddressType.billing
        ? user.billingAddress
        : user.shippingAddress;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListBody(
        children: <Widget>[
          StyledFormField(
            validator:
                RequiredValidator(errorText: context.l10n.streetIsRequired),
            style: TextStyle(color: Theme.of(context).focusColor),
            keyboardType: TextInputType.streetAddress,
            hintText: context.l10n.bajkalska,
            labelText: context.l10n.street,
            initialValue: address?.streetName,
            onSaved: (input) {
              if (input != null) {
                profileData['streetName'] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData['streetName']}');
            },
          ),
          StyledFormField(
            style: TextStyle(color: Theme.of(context).focusColor),
            validator: RequiredValidator(
                errorText: context.l10n.streetNumberIsRequired),
            keyboardType: TextInputType.streetAddress,
            hintText: '12/45',
            labelText: context.l10n.streetNumber,
            initialValue: address?.streetNumber,
            onSaved: (input) {
              if (input != null) {
                profileData['streetNumber'] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData['streetNumber']}');
            },
          ),
          StyledFormField(
            style: TextStyle(color: Theme.of(context).focusColor),
            validator:
                RequiredValidator(errorText: context.l10n.cityIsRequired),
            keyboardType: TextInputType.text,
            hintText: context.l10n.bratislava,
            labelText: context.l10n.city,
            initialValue: address?.city,
            onSaved: (input) {
              if (input != null) {
                profileData['city'] = input;
              }
              _logger
                  .fine('field saved $input, profile: ${profileData['city']}');
            },
          ),
          StyledFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(color: Theme.of(context).focusColor),
            validator: MultiValidator(
              [
                RequiredValidator(errorText: context.l10n.zipCodeIsRequired),
                LengthRangeValidator(
                    min: 5, max: 6, errorText: context.l10n.enterAValidZipCode)
              ],
            ),
            keyboardType: TextInputType.number,
            hintText: '841 02',
            labelText: context.l10n.zipCode,
            initialValue: address?.zipCode,
            onSaved: (input) {
              if (input != null) {
                profileData['zipCode'] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData['zipCode']}');
            },
          ),
          StyledFormField(
            enabled: false,
            readOnly: true,
            autovalidateMode: AutovalidateMode.disabled,
            style: TextStyle(color: Theme.of(context).focusColor),
            labelText: context.l10n.country,
            initialValue: context.l10n.slovakiaPlaceholder,
            onSaved: null,
            validator: null,
          ),
          if (addressType == AddressType.billing)
            CheckboxListTileFormField(
              activeColor: Theme.of(context).colorScheme.secondary,
              title: Text(
                context.l10n.useAsShippingAddress,
                style: Theme.of(context).textTheme.bodyText2!.merge(
                      TextStyle(color: Theme.of(context).hintColor),
                    ),
              ),
              initialValue: user.billingAddress == user.shippingAddress,
              onSaved: (value) {
                if (value != null) {
                  profileData['billingOnly'] = value;
                }
                _logger.fine(
                    'check saved $value, profile: ${profileData['billingOnly']}');
              },
            ),
        ],
      ),
    );
  }

  Row buildDialogTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}
