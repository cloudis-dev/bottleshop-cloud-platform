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
import 'package:delivery/src/core/presentation/widgets/styled_form_field.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordForm extends HookConsumerWidget {
  final ValueChanged<bool> authCallback;

  const ResetPasswordForm({Key? key, required this.authCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final formValid = ref.watch(formValidProvider);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () {
        if (email.text.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              ref.read(formValidProvider.notifier).formValid =
                  formKey.currentState!.validate();
            },
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(context.l10n.sign_in,
              style: Theme.of(context).textTheme.headline4),
          StyledFormField(
            keyboardType: TextInputType.emailAddress,
            labelText: context.l10n.email,
            autovalidateMode: AutovalidateMode.disabled,
            prefixIcon: const Icon(
              Icons.mail_outline,
            ),
            controller: email,
            validator: createEmailValidator(context),
            onSaved: (value) => email.text = value!,
          ),
          ElevatedButton(
            onPressed: formValid
                ? () async {
                    formKey.currentState!.save();
                    var currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                    final result = await ref
                        .read(userRepositoryProvider)
                        .sendResetPasswordEmail(context, email.text);
                    email.clear();
                    authCallback(result);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70),
            ),
            child: Text(
              context.l10n.reset,
            ),
          ),
        ],
      ),
    );
  }
}
