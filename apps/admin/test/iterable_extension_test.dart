import 'package:bottleshop_admin/utils/iterable_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Interleave function', () {
    test('Item sould be interleaved', () {
      final lst = [1, 2, 3, 4];

      expect(lst.interleave(5), [1, 5, 2, 5, 3, 5, 4]);
    });

    test('Single item list interleave', () {
      final lst = [1];

      expect(lst.interleave(5), [1]);
    });

    test('Empty list interleave', () {
      final lst = <int>[];

      expect(lst.interleave(5), <int>[]);
    });
  });

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  group('Distinct function', () {
    test('Basic type distinct', () {
      final lst = [1, 2, 3, 1, 2, 3];

      expect(lst.distinct((element) => element), [1, 2, 3]);
    });

    test('Basic type distinct', () {
      final lst = [1, 2, 3, 1, 2, 3];
      final stringLst = ['Abc', 'Abc', 'abc', 'Hello'];

      expect(lst.distinct((element) => element), [1, 2, 3]);
      expect(stringLst.distinct((element) => element), ['Abc', 'abc', 'Hello']);
    });

    test('List type distinct', () {
      final lst = [
        [1, 2],
        [1, 2],
        [1, 3],
        [2, 3],
        [3, 2]
      ];

      expect(lst.distinct((element) => element), [
        [1, 2],
        [1, 3],
        [2, 3],
        [3, 2]
      ]);
    });

    test('Nested list type distinct', () {
      final lst = [
        [
          1,
          [1, 2]
        ],
        [
          1,
          [2, 3]
        ],
        [
          1,
          [1, 2]
        ],
        [
          2,
          [1, 1]
        ],
        [
          3,
          [1]
        ],
        [
          1,
          [2, 3]
        ]
      ];

      expect(lst.distinct((element) => element), [
        [
          1,
          [1, 2]
        ],
        [
          1,
          [2, 3]
        ],
        [
          2,
          [1, 1]
        ],
        [
          3,
          [1]
        ],
      ]);
    });

    test('Selector distinct', () {
      final lst = [
        {'a': 1, 'b': 2},
        {'a': 1, 'b': 3},
        {'a': 2, 'c': 2},
      ];

      expect(lst.distinct((element) => element['a']), [
        {'a': 1, 'b': 2},
        {'a': 2, 'c': 2},
      ]);
    });
  });
}
