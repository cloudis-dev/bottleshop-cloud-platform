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

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/data/services/product_search_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SearchState {
  /// When nothing is in the search bar
  cleaned,

  /// When a user is currently typing and o search has started yet
  typing,

  /// When waiting for the search results
  waiting,

  /// When results of the search are there
  completed,

  /// In case of an error
  error,
}

final searchResultsProvider = StateProvider.autoDispose<
    Tuple3<SearchState, List<Tuple2<Map<SearchMatchField, String>, ProductModel>>, List<CategoryPlainModel>>>(
  (_) => const Tuple3(SearchState.cleaned, [], []),
);

final debounceTimerProvider = StateProvider.autoDispose<Timer?>(((_) => null));
final lastQueriedSearchTimeProvider = StateProvider.autoDispose<DateTime?>(((ref) => null));
final previousQuery = StateProvider.autoDispose<String?>(((_) => null));
