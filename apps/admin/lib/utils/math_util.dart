class MathUtil {
  MathUtil._();

  static const double epsilon = 0.0001;

  static bool approximately(double a, double b, {epsilon = epsilon}) =>
      (a - b).abs() < epsilon;
}
