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

import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

final authProvider = Provider<AuthenticationService>(((ref) => throw UnimplementedError()));

final authStateChangesProvider =
    StreamProvider.autoDispose<User?>((ref) => ref.watch(authProvider.select((value) => value.authStateChanges)));

final currentUserProvider = Provider<UserModel?>((ref) {
  final user = ref.watch(userRepositoryProvider.select((value) => value.user));
  return user;
});

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

final authStatusProvider = Provider<AuthStatus>((ref) {
  final authState = ref.watch(userRepositoryProvider.select((value) => value.status));
  return authState;
});

final userRepositoryProvider = ChangeNotifierProvider<UserRepository>((ref) {
  final auth = ref.watch(authProvider);
  final push = ref.watch(pushNotificationsProvider);
  final cloudFunctions = ref.watch(cloudFunctionsProvider);
  return UserRepository.instance(auth, push, cloudFunctions);
});

class TermsAcceptedState extends StateNotifier<bool> {
  final Ref ref;

  TermsAcceptedState(this.ref, {required bool initialState}) : super(initialState);

  void _storeState() {
    final preferences = ref.read(sharedPreferencesServiceProvider);
    preferences.setTermsAgreed(termsAgreed: state);
  }

  void acceptTerms() {
    state = true;
    _storeState();
  }

  void rejectTerms() {
    state = false;
    _storeState();
  }

  bool get termsAccepted => state;
}

final termsAcceptanceProvider = StateNotifierProvider<TermsAcceptedState, bool>((ref) {
  final preferences = ref.watch(sharedPreferencesServiceProvider);
  final initialState = preferences.getTermsAgreed();
  return TermsAcceptedState(ref, initialState: initialState);
});

final widgetToggleProvider = StateProvider<bool>((ref) => true, name: 'widgetToggleProvider');

final formValidProvider = StateProvider<bool>((ref) => true, name: 'formValidProvider');

final isAppVersionCompatible = StreamProvider.autoDispose<bool>(
  (ref) {
    if (kIsWeb) {
      return Stream.value(true);
    }

    return FirebaseFirestore.instance
        .collection(FirestoreCollections.versionConstraintsCollection)
        .doc('main_app')
        .snapshots()
        .map((event) => event.get('min_version'))
        .asyncMap((minBuildNum) async {
      final packageInfo = await PackageInfo.fromPlatform();
      return Version.parse(packageInfo.version) >= Version.parse(minBuildNum);
    });
  },
);

final appDownloadRedirectUrlProvider = FutureProvider.autoDispose<String>(
  (_) async {
    return FirebaseFirestore.instance
        .collection(FirestoreCollections.versionConstraintsCollection)
        .doc('main_app')
        .get()
        .then(
          (value) => value
              .data()![defaultTargetPlatform == TargetPlatform.android ? 'download_url_android' : 'download_url_ios'],
        );
  },
);
