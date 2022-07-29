import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/models/admin_user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loggedUserProvider = StateProvider<AdminUserModel?>((_) => null);

final authStateChangesProvider = StreamProvider<AdminUserModel?>(
  (ref) => ref.read(authenticationServiceProvider).adminAuthStateChanges,
);
