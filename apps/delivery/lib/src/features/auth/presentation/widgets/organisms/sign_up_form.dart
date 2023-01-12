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
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/molecules/social_media_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpForm extends HookConsumerWidget {
  final ValueChanged<bool> authCallback;

  final BorderRadiusGeometry borderRadius;
  final Color? backgroundColor;

  SignUpForm({
    Key? key,
    required this.authCallback,
    BorderRadiusGeometry? borderRadius,
    this.backgroundColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(20),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final email = useTextEditingController();
    final password = useTextEditingController();
    final passwordRepeat = useTextEditingController();
    final showPassword = useState<bool>(false);
    final isAppleAvailable = ref.watch(appleSignInAvailableProvider);

    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: () {
            if (email.text.isNotEmpty &&
                password.text.isNotEmpty &&
                passwordRepeat.text.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(signUpFormValidProvider.notifier).formValid =
                    formKey.currentState!.validate();
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.l10n.sign_up,
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
                  icon: Icon(showPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                controller: password,
                validator: createPasswordValidator(context),
                obscureText: !showPassword.value,
                onSaved: (value) => password.text = value!,
              ),
              StyledFormField(
                labelText: context.l10n.password,
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () => showPassword.value = !showPassword.value,
                  icon: Icon(showPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                controller: passwordRepeat,
                validator: (val) =>
                    MatchValidator(errorText: context.l10n.passwordsDontMatch)
                        .validateMatch(val!, password.value.text),
                obscureText: !showPassword.value,
                maxLines: 1,
                onChanged: (value) => null,
                onSaved: (value) => password.text = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: ref.watch(signUpButtonEnabledProvider)
                    ? () async {
                        var currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        }
                        final result = await ref
                            .read(userRepositoryProvider)
                            .signUpWithEmailAndPassword(
                              context,
                              email.text,
                              password.text,
                            );
                        authCallback(result);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  context.l10n.sign_up,
                ),
              ),
              const SizedBox(height: 8),
              isAppleAvailable.when(
                data: (isAppleSupported) => SocialMediaButtonsRow(
                  enabled: ref.watch(termsAcceptanceProvider),
                  isAppleSupported: isAppleSupported,
                  authCallback: authCallback,
                ),
                loading: () => const Loader(),
                error: (_, __) => SocialMediaButtonsRow(
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

class SignUpFormState extends StateNotifier<bool> {
  set formValid(bool formValid) => state = formValid;

  bool get formValid => state;

  SignUpFormState() : super(false);
}

final signUpFormValidProvider =
    StateNotifierProvider.autoDispose<SignUpFormState, bool>(
  (ref) => SignUpFormState(),
);

final signUpButtonEnabledProvider = Provider.autoDispose<bool>((ref) {
  final termsAgreed = ref.watch(termsAcceptanceProvider);
  final formValid = ref.watch(signUpFormValidProvider);
  return termsAgreed && formValid;
});
