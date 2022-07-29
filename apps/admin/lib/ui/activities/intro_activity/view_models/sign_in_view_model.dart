import 'package:bottleshop_admin/core/data/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

class SignInViewModel extends StateNotifier<Tuple2<bool, String?>> {
  SignInViewModel(this.authService) : super(Tuple2(false, null));

  final AuthenticationService authService;

  // bool get isLoading => state.item1;
  // String get error => state.item2;

  set error(String err) {
    if (mounted) {
      state = Tuple2(state.item1, err);
    }
  }

  set _isLoading(bool isLoading) {
    if (mounted) {
      state = Tuple2(isLoading, state.item2);
    }
  }

  Future signIn(String email, String password) async {
    try {
      _isLoading = true;
      await authService.signIn(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      error = dispatchAuthException(e);
    } finally {
      _isLoading = false;
    }
  }

  String dispatchAuthException(Object ex) {
    if (ex is FirebaseAuthException) {
      switch (ex.code) {
        case 'invalid-email':
          return 'Zlá email adresa.';
        case 'wrong-password':
          return 'Zlé heslo.';
        case 'user-not-found':
          return 'Admin používateľ s týmto emailom neexistuje.';
        case 'user-disabled':
          return 'Používateľ s týmto emailom bol deaktivovaný.';
        case 'network-request-failed':
          return 'Skontrolujte pripojenie k sieti a skúste znova.';
        default:
          return 'Nastala nedefinovaná chyba.';
      }
    } else {
      return 'Nastala nedefinovaná chyba.';
    }
  }
}
