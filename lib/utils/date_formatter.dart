// lib/utils/date_formatter.dart

class DateFormatter {
  static String format(String dateString) {
    try {
      // Handle both formats: with timestamp (2025-01-24T06:39:29.617+00:00) and without (2025-01-18)
      final dateTime = DateTime.parse(dateString);
      final day = dateTime.day;
      final month = _getMonthName(dateTime.month);
      final year = dateTime.year;
      return '$day${_getOrdinalSuffix(day)} $month, $year';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  static String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}