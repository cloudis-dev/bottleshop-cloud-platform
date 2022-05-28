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

import 'dart:collection';

import 'package:collection/collection.dart';

extension IterableExtension<T> on Iterable<T> {
  T? tryGetById(int id) {
    return id < length ? elementAt(id) : null;
  }

  /// Having a sequence [A, B, C]. After applying this function with the element E.
  /// The resulting sequence will be [A, E, B, E, C].
  Iterable<T> interleave(T element) => Iterable<int>.generate(length).expand(
        (e) => e == length - 1 ? [elementAt(e)] : [elementAt(e), element],
      );

  /// Returns only distinct elements of an iterable according to the selector parameter.
  /// When the parameter [firstOccurenceRemains] is true, then all the first occurences remain,
  /// the others go away.
  /// Otherwise the last occurences remain and the others go away.
  List<T> distinct<E>(
    E Function(T element) selectorForEqualityComparison, {
    required bool firstOccurenceRemains,
  }) {
    // Load all the unique keys into the linked hash set remaining its ordering.
    final set = LinkedHashSet<E>(
      equals: const DeepCollectionEquality().equals,
      hashCode: const DeepCollectionEquality().hash,
    ).addAll(map((e) => selectorForEqualityComparison(e)));

    return set
        .map(
          (e) => (firstOccurenceRemains ? firstWhere : lastWhere)(
            (element) => const DeepCollectionEquality().equals(selectorForEqualityComparison(element), e),
          ),
        )
        .toList();
  }
}
