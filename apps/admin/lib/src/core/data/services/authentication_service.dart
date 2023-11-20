import 'dart:async';

import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/models/admin_user_model.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/auth_providers.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthenticationService {
  AuthenticationService(this._providerRef);

  Stream<AdminUserModel?> adminAuthStateChanges =
      FirebaseAuth.instance.authStateChanges().asyncMap(_retrieveAdminUser);

  final ProviderReference _providerRef;

  static Future<AdminUserModel?> _retrieveAdminUser(User? user) async {
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance
        .collection(Constants.adminUsersCollection)
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw FirebaseAuthException(code: 'user-disabled', message: '');
    }

    return AdminUserModel.fromJson(
      userDoc.data()!,
      userDoc.id,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _providerRef
        .read(pushNotificationsProvider)
        .setAdminNotificationsSubscriptionActive(false);
    _providerRef.read(loggedUserProvider).state = null;
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.isEmpty ? ' ' : email,
        password: password.isEmpty ? ' ' : password,
      );
      assert(result.user != null);
      await _providerRef
          .read(pushNotificationsProvider)
          .setAdminNotificationsSubscriptionActive(true);

      await _retrieveAdminUser(result.user);
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<bool> isAdminUserLoggedIn() async {
    try {
      return await _retrieveAdminUser(FirebaseAuth.instance.currentUser) !=
          null;
    } catch (_) {
      return false;
    }
  }
}
