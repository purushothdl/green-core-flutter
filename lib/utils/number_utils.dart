// utils/number_utils.dart

class NumberUtils {
  static dynamic convertDouble(double input) {
    // Check if the decimal part is zero
    if (input % 1 == 0) {
      return input.toInt(); // Return as int if the decimal part is zero
    } else {
      return input; // Return as double if there's a decimal part
    }
  }
}