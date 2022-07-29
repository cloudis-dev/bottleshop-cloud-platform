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
  /// The first occurence remains. The others go away.
  List<T> distinct<E>(E Function(T element) selectorForEqualityComparison) {
    final set = LinkedHashSet(
      equals: const DeepCollectionEquality().equals,
      hashCode: const DeepCollectionEquality().hash,
    )..addAll(
        map(
          (e) => selectorForEqualityComparison(e),
        ),
      );

    return set
        .map(
          (e) => firstWhere(
            (element) => const DeepCollectionEquality()
                .equals(selectorForEqualityComparison(element), e),
          ),
        )
        .toList();
  }
}
