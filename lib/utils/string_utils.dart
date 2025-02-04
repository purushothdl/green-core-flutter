// lib/utils/util_utils.dart

String getGreeting() {
  final now = DateTime.now().toUtc();
  
  // Convert UTC to IST (UTC + 5:30)
  final istTime = now.add(const Duration(hours: 5, minutes: 30));
    final hour = istTime.hour;
  
    if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}


class StringUtils {
  static String? capitalizeFirstLetters(String? input) {
    // Return null if input is null
    if (input == null) {
      return null;
    }

    // Return empty string if input is empty
    if (input.isEmpty) {
      return input;
    }

    // Split the string into words
    List<String> words = input.split(' ');

    // Capitalize the first letter of each word
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join(' ');
  }
}