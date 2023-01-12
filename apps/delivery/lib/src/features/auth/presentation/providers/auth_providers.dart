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

import 'dart:async';

import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/data/repositories/user_repository.dart';
import 'package:delivery/src/features/auth/presentation/widgets/organisms/sign_up_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUserAsStream = StreamProvider.autoDispose<UserModel?>(
  (ref) {
    var controller = StreamController<UserModel?>();
    var user = ref.watch(userRepositoryProvider).user;
    controller.add(user);

    ref.onDispose(() async {
      await controller.close();
    });

    return controller.stream.distinct().asBroadcastStream();
  },
  name: 'currentUserAsStream',
);

final currentUserProvider = Provider<UserModel?>((ref) {
  var user = ref.watch(userRepositoryProvider).user;
  return user;
});

final appleSignInAvailableProvider = FutureProvider<bool>((ref) async {
  final auth = await ref.watch(authProvider).supportsAppleSignIn;
  return auth;
});

final authStatusProvider = Provider((ref) {
  final authState = ref.watch(userRepositoryProvider).status;
  return authState;
});

final userRepositoryProvider = ChangeNotifierProvider<UserRepository>((ref) {
  final auth = ref.watch(authProvider);
  final push = ref.watch(pushNotificationsProvider);
  final cloudFunctions = ref.watch(cloudFunctionsProvider);
  return UserRepository.instance(auth, push, cloudFunctions);
});

class TermsAcceptedState extends StateNotifier<bool> {
  final SharedPreferencesService service;

  TermsAcceptedState({required this.service}) : super(true);

  void acceptTerms() {
    state = true;
    service.setTermsAgreed(termsAgreed: true);
  }

  void rejectTerms() {
    state = false;
    service.setTermsAgreed(termsAgreed: false);
  }

  bool termsAccepted() => state;
}

final termsAcceptanceProvider =
    StateNotifierProvider.autoDispose<TermsAcceptedState, bool>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TermsAcceptedState(service: sharedPreferences);
});

class SignWidgetState extends StateNotifier<bool> {
  SignWidgetState({bool showSignIn = true}) : super(showSignIn);

  bool isSignIn() => state;

  bool isSignUp() => !state;

  void toggle() {
    state = !state;
  }
}

final widgetToggleProvider =
    StateNotifierProvider.autoDispose<SignWidgetState, bool>(
        (ref) => SignWidgetState(),
        name: 'widgetToggleProvider');

final formValidProvider =
    StateNotifierProvider.autoDispose<SignUpFormState, bool>(
        (ref) => SignUpFormState());
