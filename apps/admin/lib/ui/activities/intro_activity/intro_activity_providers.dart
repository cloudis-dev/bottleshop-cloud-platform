import 'package:bottleshop_admin/core/presentation/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'view_models/sign_in_view_model.dart';

final signInModelProvider =
    StateNotifierProvider.autoDispose<SignInViewModel, Tuple2<bool, String?>>(
  (ref) => SignInViewModel(ref.read(authenticationServiceProvider)),
);
