@JS()
library stripe;

import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:js/js.dart';

Future<void> redirectToCheckout(String sessionId) async {
  Stripe(AppEnvironment.stripePublishableKey)
    ..redirectToCheckout(CheckoutOptions(sessionId: sessionId));
}

@JS()
class Stripe {
  external Stripe(String key);

  external void redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external String get sessionId;

  external factory CheckoutOptions({
    String sessionId,
  });
}

@JS()
@anonymous
class Result {
  external String get error;

  external factory Result({
    String error,
  });
}
