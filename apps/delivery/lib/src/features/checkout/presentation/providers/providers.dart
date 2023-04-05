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

import 'package:delivery/src/features/cart/data/models/promo_code_model.dart';
import 'package:delivery/src/features/checkout/presentation/view_models/delivery_option_state.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isRedirectingProvider = StateProvider.autoDispose<bool>((ref) => false);

final orderTypeStateProvider =
    StateNotifierProvider.autoDispose<OrderTypeState, OrderTypeModel?>(
  (ref) => OrderTypeState(),
  name: 'orderTypeStateProvider',
);

final remarksTextEditCtrlProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final ctrl = TextEditingController();
    ref.onDispose(() => ctrl.dispose());
    return ctrl;
  },
);

final currentAppliedPromoProvider =
    StateProvider.autoDispose<PromoCodeModel?>((ref) {
  // reset on order type change
  ref.watch(orderTypeStateProvider);
  return null;
});
