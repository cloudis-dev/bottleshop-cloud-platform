import 'package:delivery/src/features/checkout/presentation/pages/stripejs_stub.dart'
    if (dart.library.io) 'stripejs_stub.dart'
    if (dart.library.js) 'stripejs.dart' as impl;

Future<void> redirectToCheckout(String sessionId) async {
  return impl.redirectToCheckout(sessionId);
}
