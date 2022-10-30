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
import 'package:delivery/src/features/auth/presentation/widgets/molecules/social_media_buttons_row.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/sign_up_form.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _signInFormValidProvider =
    StateNotifierProvider.autoDispose<SignUpFormState, bool>(
  (ref) => SignUpFormState(),
);

final _loginButtonEnabledProvider = Provider.autoDispose<bool>((ref) {
  final termsAgreed = ref.watch(termsAcceptanceProvider);
  final formValid = ref.watch(_signInFormValidProvider);
  return termsAgreed && formValid;
});

class SignInForm extends HookConsumerWidget {
  final ValueChanged<bool> authCallback;
  final BorderRadiusGeometry borderRadius;
  final Color? backgroundColor;

  SignInForm({
    Key? key,
    required this.authCallback,
    BorderRadiusGeometry? borderRadius,
    this.backgroundColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(20),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final showPassword = useState<bool>(false);
    final isAppleAvailable = ref.watch(appleSignInAvailableProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: () {
            if (email.text.isNotEmpty && password.text.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(_signInFormValidProvider.notifier).formValid =
                    formKey.currentState!.validate();
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.l10n.sign_in,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              StyledFormField(
                keyboardType: TextInputType.emailAddress,
                labelText: context.l10n.email,
                prefixIcon: const Icon(
                  Icons.mail_outline,
                ),
                controller: email,
                validator: createEmailValidator(context),
                onSaved: (value) => email.text = value!,
              ),
              StyledFormField(
                labelText: context.l10n.password,
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () => showPassword.value = !showPassword.value,
                  icon: Icon(
                    showPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                controller: password,
                validator: createPasswordValidator(context),
                obscureText: !showPassword.value,
                onSaved: (value) => password.text = value!,
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    context.l10n.password_forgotten,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, ResetPasswordView.routeName),
                    child: Text(
                      context.l10n.reset,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: ref.watch(_loginButtonEnabledProvider)
                    ? () async {
                        var currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        }
                        final result = await ref
                            .read(userRepositoryProvider)
                            .signInWithEmailAndPassword(
                              context,
                              email.text,
                              password.text,
                            );
                        authCallback(result);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(context.l10n.login),
              ),
              const SizedBox(height: 8),
              isAppleAvailable.maybeWhen(
                data: (data) => SocialMediaButtonsRow(
                  enabled: ref.watch(termsAcceptanceProvider),
                  isAppleSupported: data,
                  authCallback: authCallback,
                ),
                orElse: () => SocialMediaButtonsRow(
                  enabled: ref.watch(termsAcceptanceProvider),
                  authCallback: authCallback,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
