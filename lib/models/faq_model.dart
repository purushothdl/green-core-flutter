// lib/models/faq_model.dart
class FAQ {
  final String label;
  final String question;
  final String answer;

  FAQ({required this.label, required this.question, required this.answer});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      label: json['label'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}