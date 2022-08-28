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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/authentication_service.dart';
import 'package:delivery/src/core/data/services/cloud_functions_service.dart';
import 'package:delivery/src/core/data/services/push_notification_service.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/features/auth/data/models/device_model.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/auth/data/services/user_db_service.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/streams.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated
}

final _logger = Logger((UserRepository).toString());

class UserRepository extends ChangeNotifier {
  final AuthenticationService _auth;
  final PushNotificationService _notificationService;
  final CloudFunctionsService _cloudFunctionsService;
  String? _error;
  bool _loading;
  AuthStatus _status = AuthStatus.uninitialized;
  StreamSubscription<UserModel?>? _userListener;
  UserModel? _fsUser;

  String? get error => _error;

  AuthStatus get status => _status;

  UserModel? get user => _fsUser;

  bool get isLoading => _loading;

  UserRepository.instance(
    this._auth,
    this._notificationService,
    this._cloudFunctionsService,
  ) : _loading = false {
    _error = '';
    _fsUser = null;
    MergeStream<User?>([
      Stream.value(_auth.currentUser),
      _auth.authStateChanges,
    ]).listen(_onAuthStateChanged);
    _notificationService.onTokenRefreshed.listen(_onTokenRefreshed);
  }

  void handleFatalFailure() {
    _error = 'Login failed';
    _loading = false;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _logger.fine('authStateChanges: ${firebaseUser?.uid}');
    if (firebaseUser == null) {
      await _userListener?.cancel();
      _status = AuthStatus.unauthenticated;
      _fsUser = null;
      _loading = false;
      _error = '';
      notifyListeners();
    } else {
      _error = '';
      _userListener = userDb.streamSingle(firebaseUser.uid).listen((user) {
        if (user != null) {
          _fsUser = user;
          _loading = false;
          _status = AuthStatus.authenticated;
          notifyListeners();
        }
      });
      await _saveUserRecord(firebaseUser);
    }
  }

  Future<void> setPreferredLanguage(String langCode) async {
    if (user == null) return;

    await _auth.setLanguage(langCode);
    return userDb.updateData(user!.uid, {
      UserFields.preferredLanguage: langCode,
    });
  }

  Future<void> onUserChangedPreferredLanguage(LanguageMode mode) async {
    return setPreferredLanguage(language2Locale(mode).languageCode);
  }

  Future<void> sendVerificationMail() async {
    return _auth.currentUser!.sendEmailVerification();
  }

  Future<void> checkUserVerified() async {
    await _auth.currentUser?.reload();
    // Why do we do this twice??? await _auth.currentUser?.reload();
    if (_auth.currentUser?.emailVerified ?? false) {
      await userDb.updateData(_auth.currentUser!.uid, {
        UserFields.isEmailVerified: true,
      });
    }
  }

  Future<void> _saveUserRecord(User? firebaseUser) async {
    if (firebaseUser == null) return;
    final userModel = UserModel.fromFirebaseUser(user: firebaseUser);

    if (userModel == null) return;

    // final existingUser = await userDb.exists(firebaseUser.uid);
    if (!await userDb.exists(firebaseUser.uid)) {
      final stripeId =
          await _cloudFunctionsService.createStripeCustomer(userModel);

      if (stripeId == null) {
        _logger.severe('Could not create stripe customer');
      } else {
        await userDb.create(
          userModel
              .copyWith(
                  stripeCustomerId: stripeId,
                  preferredLanguage: Intl.getCurrentLocale().substring(0, 2))
              .toMap(),
          id: firebaseUser.uid,
        );
      }
      await _saveDevice(firebaseUser.uid);
    } else {
      await _saveDevice(firebaseUser.uid);
      await userDb.updateData(firebaseUser.uid, {
        UserFields.lastLoggedIn: FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _saveDevice(String? uid) async {
    if (uid == null) {
      return;
    }
    String deviceId;
    DeviceDetails? deviceDescription;
    if (!kIsWeb) {
      var devicePlugin = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        var deviceInfo = await devicePlugin.androidInfo;
        deviceId = deviceInfo.androidId;
        deviceDescription = DeviceDetails(
          device: deviceInfo.device,
          model: deviceInfo.model,
          osVersion: deviceInfo.version.sdkInt.toString(),
          platform: 'android',
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        var deviceInfo = await devicePlugin.iosInfo;
        deviceId = deviceInfo.identifierForVendor;
        deviceDescription = DeviceDetails(
          osVersion: deviceInfo.systemVersion,
          device: deviceInfo.name,
          model: deviceInfo.utsname.machine,
          platform: 'ios',
        );
      } else {
        throw PlatformException(code: 'No such platform');
      }
    } else {
      deviceId = 'browser';
      deviceDescription = DeviceDetails(
        device: 'browser',
        model: 'N/A',
        osVersion: 'N/A',
        platform: 'web',
      );
    }

    userDeviceDb.collection = FirestorePaths.userDevices(uid);
    final existing = await userDeviceDb.getSingle(deviceId);
    var token = await _notificationService.currentToken;
    _logger.fine('FCM Token: $token');
    if (existing != null) {
      if (token != null) {
        await userDeviceDb.updateData(deviceId, {
          DeviceFields.lastUpdatedAt: DateTime.now().toUtc(),
          DeviceFields.token: token,
        });
      }
    } else {
      var device = Device(
        createdAt: DateTime.now().toUtc(),
        lastUpdatedAt: DateTime.now().toUtc(),
        deviceInfo: deviceDescription,
        id: deviceId,
        token: token,
      );
      await userDeviceDb.create(device.toMap(), id: deviceId);
    }
  }

  Future<void> _onTokenRefreshed(String token) async {
    if (_fsUser?.uid != null) {
      final uid = _fsUser?.uid;
      await _saveDevice(uid);
    }
    _logger.fine('onTokenRefreshed: $token');
  }

  Future<bool> sendResetPasswordEmail(
      BuildContext context, String email) async {
    try {
      _loading = true;
      notifyListeners();
      await _auth.setLanguage(Intl.getCurrentLocale().substring(0, 2));
      await _auth.sendPasswordResetEmail(email);
      _error = '';
      return true;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'sendResetPasswordEmail FirebaseAuthException error', err, stack);
      _error = _getAuthenticationErrorMessage(context, err.code);
      return false;
    } catch (err, stack) {
      _logger.severe('sendResetPasswordEmail error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email, password);
      // TODO: if createStripeCustomer fails, user is in Auth but not in Firestore!
      // Then creating user throws an email-already-in-use exception code.
      await sendVerificationMail();
      // Why do we do this twice???? await _auth.currentUser!.sendEmailVerification();
      _error = '';
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'signUpWithEmailAndPassword FirebaseAuthException error', err, stack);

      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
    } catch (err, stack) {
      _logger.severe('signUpWithEmailAndPassword error', err, stack);

      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
    } finally {
      _loading = false;
      notifyListeners();
    }

    return _error?.isEmpty ?? true;
  }

  Future<void> setUserIntroSeen() async {
    if (_fsUser == null) return;

    if (_status == AuthStatus.authenticated &&
        _fsUser!.uid != 'signed-out' &&
        !_fsUser!.introSeen) {
      await userDb.updateData(_fsUser!.uid, {
        UserFields.lastLoggedIn: FieldValue.serverTimestamp(),
        UserFields.introSeen: true,
      });
    }
  }

  Future<bool> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email, password);
      _error = '';
      return true;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'signInWithEmailAndPassword FirebaseAuthException error', err, stack);
      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } catch (err, stack) {
      _logger.severe('signInWithEmailAndPassword error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithGoogle(BuildContext context) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      if (kIsWeb) {
        await _auth.signInWithGoogleWeb();
      } else {
        await _auth.signInWithGoogle();
      }
      _error = '';
      return true;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'signUpWithGoogle FirebaseAuthException error', err, stack);
      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } catch (err, stack) {
      _logger.severe('signUpWithGoogle error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithFacebook(BuildContext context) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      if (kIsWeb) {
        await _auth.signInWithFacebookWeb();
      } else {
        await _auth.signInWithFacebook();
      }
      _error = '';
      return true;
    } on PlatformException catch (err, stack) {
      _logger.severe('signUpWithFacebook PlatformException error', err, stack);

      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'signUpWithFacebook FirebaseAuthException error', err, stack);

      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } catch (err, stack) {
      _logger.severe('signUpWithFacebook error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } finally {}
  }

  Future<bool> signUpAnonymously(BuildContext context) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      await _auth.signInAnonymously();
      _error = '';
      return true;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe(
          'signUpAnonymously FirebaseAuthException error', err, stack);
      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } catch (err, stack) {
      _logger.severe('signUpAnonymously error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithApple(BuildContext context) async {
    try {
      _status = AuthStatus.authenticating;
      _loading = true;
      notifyListeners();
      await _auth.signWithApple();
      _error = '';
      return true;
    } on FirebaseAuthException catch (err, stack) {
      _logger.severe('signUpWithApple FirebaseAuthException error', err, stack);
      _error = _getAuthenticationErrorMessage(context, err.code);
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    } catch (err, stack) {
      _logger.severe('signUpWithApple error', err, stack);
      _error = _getAuthenticationErrorMessage(context, '');
      _status = AuthStatus.unauthenticated;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _userListener?.cancel();
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _logger.fine('authState: disposed');
    _userListener?.cancel();
    super.dispose();
  }

  String _getAuthenticationErrorMessage(
      BuildContext context, String errorCode) {
    switch (errorCode) {
      case ('CANCELLED'):
      case ('FAILED'):
        return context.l10n.unableToAuthenticatePleaseTryAgainLater;
      case ('email-already-in-use'):
        return context.l10n.userWithThisEmailAlreadyExists;
      case ('user-not-found'):
        return context.l10n.userWithThisEmailNotFound;
      case ('wrong-password'):
        return context.l10n.incorrectPassword;
      case ('account-exists-with-different-credential'):
        return context.l10n.userAlreadySignedUpWithDifferentProvider;
      default:
        return context.l10n.unableToAuthenticatePleaseTryAgainLater;
    }
  }
}
