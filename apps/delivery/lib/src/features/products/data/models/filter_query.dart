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

import 'package:delivery/src/core/utils/iterable_extension.dart';
import 'package:flutter/material.dart';

class FilterQuery {
  final FilterLogicOp logicOp;

  final List<SingleLogicOpQuery> queries;

  FilterQuery(this.logicOp, this.queries);

  @override
  String toString() {
    final query = queries
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .interleave(logicOp == FilterLogicOp.and ? ' AND ' : ' OR ')
        .join();
    return '$query';
  }
}

class SingleLogicOpQuery {
  final FilterLogicOp logicOp;

  final List<FilterFieldQuery> fieldsQueries;

  SingleLogicOpQuery(this.logicOp, this.fieldsQueries);

  @override
  String toString() {
    final query = fieldsQueries
        .map((e) => e.toString())
        .interleave(logicOp == FilterLogicOp.and ? ' AND ' : ' OR ')
        .join();
    return query.trim().isEmpty ? '' : '($query)';
  }
}

enum FilterLogicOp { and, or }

class FilterFieldQuery {
  final String field;

  /// Less than or equals
  final String? lte;

  /// Greater than or equals
  final String? gte;

  /// Greater than
  final String? gt;

  /// Less than
  final String? lt;

  /// Equals
  final String? eq;

  /// Not equals
  final String? notEq;

  final RangeValues? range;

  final String? facet;

  FilterFieldQuery(
    this.field, {
    this.lte,
    this.gte,
    this.gt,
    this.lt,
    this.eq,
    this.notEq,
    this.range,
    this.facet,
  }) : assert([lte, gte, gt, lt, eq, notEq, range, facet]
                .where((element) => element != null)
                .length ==
            1); // only a single operation set

  @override
  String toString() {
    String? sign;
    if (lte != null) {
      sign = '<= $lte';
    } else if (gte != null) {
      sign = '>= $gte';
    } else if (gt != null) {
      sign = '> $gt';
    } else if (lt != null) {
      sign = '< $lt';
    } else if (eq != null) {
      sign = '= $eq';
    } else if (notEq != null) {
      sign = '!= $notEq';
    } else if (range != null) {
      sign = ':${range!.start} TO ${range!.end}';
    } else if (facet != null) {
      sign = ':$facet';
    }

    return '$field $sign';
  }
}
