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

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/styled_form_field.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/data/services/user_db_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';

final _logger = Logger((ProfileSettingsDialog).toString());

class ProfileSettingsDialog extends HookWidget {
  final bool? showBirthday;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProfileSettingsDialog({Key? key, this.showBirthday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useProvider(currentUserProvider);
    final currentLocale = useProvider(currentLocaleProvider);
    final scrollController = useScrollController();
    var profileData = <String, dynamic>{};

    return TextButton(
      onPressed: user == null
          ? null
          : () async {
              await showProfileDialog(
                context: context,
                controller: scrollController,
                user: user,
                profileData: profileData,
                formatter: FormattingUtils.getDateFormatter(currentLocale),
              );
            },
      style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary),
      child: Text(
        context.l10n.edit,
      ),
    );
  }

  Future<void> showProfileDialog({
    required BuildContext context,
    required ScrollController controller,
    required UserModel user,
    Map<String, dynamic>? profileData,
    DateFormat? formatter,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: buildDialogTitle(context, context.l10n.profileSettings),
          content: CupertinoScrollbar(
            thumbVisibility: true,
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              child: buildProfileForm(
                context: context,
                user: user,
                profileData: profileData,
                formatter: formatter,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                var isValid = _formKey.currentState!.validate();
                if (isValid) {
                  _formKey.currentState!.save();
                  userDb.updateData(user.uid, profileData!);
                  showSimpleNotification(
                    Text(context.l10n.profileUpdated),
                    position: NotificationPosition.top,
                    duration: const Duration(seconds: 2),
                    slideDismissDirection: DismissDirection.horizontal,
                    context: context,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
  }

  Form buildProfileForm({
    required BuildContext context,
    required UserModel user,
    Map<String, dynamic>? profileData,
    DateFormat? formatter,
  }) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListBody(
        children: <Widget>[
          StyledFormField(
            initialValue: user.email,
            keyboardType: TextInputType.emailAddress,
            labelText: '${context.l10n.email}*',
            onSaved: (input) {
              if (input != null) {
                profileData![UserFields.email] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData![UserFields.email]}');
            },
            validator: MultiValidator(
              <FieldValidator<dynamic>>[
                RequiredValidator(errorText: context.l10n.emailIsRequired),
                EmailValidator(errorText: context.l10n.email_invalid),
              ],
            ),
          ),
          StyledFormField(
            keyboardType: TextInputType.name,
            labelText: '${context.l10n.fullName}*',
            initialValue: user.name,
            validator: MultiValidator(
              <FieldValidator<dynamic>>[
                RequiredValidator(errorText: context.l10n.fullNameIsRequired),
                MinLengthValidator(3,
                    errorText: context.l10n.fullNameMustBeLonger),
              ],
            ),
            onSaved: (input) {
              if (input != null) {
                profileData![UserFields.name] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData![UserFields.name]}');
            },
          ),
          StyledFormField(
            keyboardType: TextInputType.phone,
            validator: MultiValidator([
              RequiredValidator(errorText: context.l10n.phoneNumberIsRequired),
              LengthRangeValidator(
                  min: 10,
                  max: 13,
                  errorText: context.l10n.enterValidPhoneNumber),
            ]),
            hintText: '+421 9xx xxx xxx',
            labelText: '${context.l10n.phoneNumber}*',
            initialValue: user.phoneNumber,
            onSaved: (input) {
              if (input != null) {
                profileData![UserFields.phoneNumber] = input;
              }
              _logger.fine(
                  'field saved $input, profile: ${profileData![UserFields.phoneNumber]}');
            },
          ),
          if (showBirthday!)
            DateTimeField(
              resetIcon: null,
              decoration: getInputFieldDecorator(
                context: context,
                hintText: context.l10n.yyyymmdd,
                labelText: context.l10n.dayOfBirth,
              ),
              format: formatter!,
              initialValue: user.dayOfBirth,
              onShowPicker: (context, initialDate) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: initialDate ??
                      (DateTime.now().subtract(const Duration(days: 365 * 18))),
                  lastDate:
                      (DateTime.now().subtract(const Duration(days: 365 * 18))),
                  initialDatePickerMode: DatePickerMode.year,
                  helpText: context.l10n.selectYourDayOfBirth,
                );
                return date;
              },
              onSaved: (input) {
                if (input != null) {
                  profileData![UserFields.dayOfBirth] = input;
                }
                _logger.fine('field saved ${input.toString()}');
              },
            ),
        ],
      ),
    );
  }

  Row buildDialogTitle(BuildContext context, String title) {
    return Row(
      children: <Widget>[
        const Icon(Icons.supervised_user_circle_outlined),
        const SizedBox(width: 10),
        Text(
          title,
        )
      ],
    );
  }
}
