class DiscountUtil {
  DiscountUtil._();

  static int getPercentageFromDiscount(double discount) =>
      (discount.clamp(0, 1) * 100).round();

  static double getDiscountFromPercentage(int percentage) =>
      percentage.clamp(0, 100).toDouble() / 100;

  static double getDiscountMultiplier(double discount) =>
      1 - discount.clamp(0, 1);
}
