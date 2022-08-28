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

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _logger = Logger((AuthenticationService).toString());

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookLogin;

  AuthenticationService({
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookLogin,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: AppEnvironment.googleSignInScopes),
        _facebookLogin = facebookLogin ?? FacebookAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> setLanguage(String langCode) async {
    return _firebaseAuth.setLanguageCode(langCode);
  }

  Future<void> _signUserWithAuthCredential(AuthCredential credential) async {
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _signUserWithAuthCredential(credential);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<void> signInWithGoogleWeb() async {
    final googleAuthProvider = GoogleAuthProvider();
    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
    final authCredential = userCredential.credential;
    if (authCredential == null) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
    await _signUserWithAuthCredential(authCredential);
  }

  Future<String> signInWithFacebook() async {
    var loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      final facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      var credential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      return credential.credential!.providerId;
    } else if (loginResult.status == LoginStatus.cancelled) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    } else {
      throw PlatformException(
          code: 'ERROR_FACEBOOK_AUTH',
          message: 'Unable to sing in to Facebook');
    }
  }

  Future<void> signInWithFacebookWeb() async {
    try {
      var facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email').setCustomParameters({
        'display': 'popup',
      });
      await FirebaseAuth.instance.signInWithPopup(facebookProvider);
    } catch (err) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  String _createNonce(int length) {
    final random = Random();
    final charCodes = List<int?>.generate(length, (_) {
      int? codeUnit;

      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });

    return String.fromCharCodes(charCodes as Iterable<int>);
  }

  Future<void> signWithApple() async {
    final nonce = _createNonce(32);
    final nativeAppleCred = defaultTargetPlatform == TargetPlatform.iOS
        ? await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          )
        : await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              redirectUri: Uri.parse(AppEnvironment.appleSignInRedirectUri),
              clientId: AppEnvironment.appleSignInClientId,
            ),
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          );
    var authCredential = OAuthCredential(
      providerId: 'apple.com',
      // MUST be "apple.com"
      signInMethod: 'oauth',
      // MUST be "oauth"
      accessToken: nativeAppleCred.identityToken,
      // propagate Apple ID token to BOTH accessToken and idToken parameters
      idToken: nativeAppleCred.identityToken,
      rawNonce: nonce,
    );
    await _signUserWithAuthCredential(authCredential);
  }

  Future<bool> get supportsAppleSignIn async {
    var supportsAppleSignIn = false;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      supportsAppleSignIn = await SignInWithApple.isAvailable();
    }
    return supportsAppleSignIn;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookLogin.logOut();
      return _firebaseAuth.signOut();
    } catch (err, stack) {
      _logger.severe('signOut failed', err, stack);
    }
  }

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
