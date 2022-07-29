class LogicalUtils {
  LogicalUtils._();

  /// Logical table:
  ///
  /// | a | b | Y |
  /// ____________
  /// | F | F | F |
  ///
  /// | F | T | T |
  ///
  /// | T | F | T |
  ///
  /// | T | T | F |
  static bool xor(bool a, bool b) => (a && !b) || (!a && b);

  /// Logical table:
  ///
  /// | a | b | Y |
  /// ____________
  /// | F | F | T |
  ///
  /// | F | T | T |
  ///
  /// | T | F | F |
  ///
  /// | T | T | T |
  static bool implication(bool a, bool b) => !a || b;
}
