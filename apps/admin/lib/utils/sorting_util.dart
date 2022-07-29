import 'package:diacritic/diacritic.dart';

class SortingUtil {
  SortingUtil._();

  static int stringSortCompare(String a, String b) =>
      removeDiacritics(a.toLowerCase())
          .compareTo(removeDiacritics(b.toLowerCase()));
}
