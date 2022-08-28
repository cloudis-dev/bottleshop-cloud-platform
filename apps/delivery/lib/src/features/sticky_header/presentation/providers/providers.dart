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

import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterValue<T> extends Equatable {
  final T value;
  final void Function() onDeleteFilter;

  const FilterValue({
    required this.value,
    required this.onDeleteFilter,
  });

  @override
  List<Object?> get props => [value];
}

final alcoholRangeScopedProvider =
    ScopedProvider<FilterValue<RangeValues>>(null);

final quantityScopedProvider = ScopedProvider<FilterValue<int>>(null);

final volumeRangeScopedProvider =
    ScopedProvider<FilterValue<RangeValues>>(null);

final priceRangeScopedProvider = ScopedProvider<FilterValue<RangeValues>>(null);

final isSpecialEditionScopedProvider = ScopedProvider<FilterValue<bool>>(null);

final countriesScopedProvider =
    ScopedProvider<FilterValue<List<CountryModel>>>(null);

final minAgeScopedProvider = ScopedProvider<FilterValue<int>>(null);
final maxYearScopedProvider = ScopedProvider<FilterValue<int>>(null);

final extraCategoriesScopedProvider =
    ScopedProvider<FilterValue<List<String>>>(null);
