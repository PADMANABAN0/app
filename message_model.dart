class BirthdayMessage {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? from;

  BirthdayMessage({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.from,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'from': from,
    };
  }

  factory BirthdayMessage.fromJson(Map<String, dynamic> json) {
    return BirthdayMessage(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      from: json['from'],
    );
  }
}
