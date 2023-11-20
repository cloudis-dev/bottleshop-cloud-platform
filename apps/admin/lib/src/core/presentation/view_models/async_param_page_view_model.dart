import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncParamPageViewModel<T> extends StateNotifier<AsyncValue<T>> {
  AsyncParamPageViewModel() : super(const AsyncValue.loading());

  StreamSubscription<dynamic>? _subscription;
  bool _isLoaded = false;

  @override
  Future<void> dispose() async {
    super.dispose();
    await _subscription?.cancel();
  }

  void load(Stream<T> parameterStream) {
    assert(!_isLoaded, 'Can be loaded only once');
    _isLoaded = true;

    _subscription = parameterStream.listen(
      (event) {
        state = AsyncValue.data(event);
      },
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }
}
