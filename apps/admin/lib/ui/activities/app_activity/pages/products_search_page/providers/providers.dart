import 'dart:async';

import 'package:bottleshop_admin/core/data/services/products_search_service.dart';
import 'package:bottleshop_admin/models/product_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

final searchResultsProvider = StateProvider.autoDispose<
    AsyncValue<List<Tuple2<Map<SearchMatchField, String>, ProductModel>>>>(
  (_) => AsyncValue.data([]),
);

final debounceTimerProvider = StateProvider<Timer?>((_) => null);
final lastQueriedSearchTimeProvider = StateProvider<DateTime?>((ref) => null);
