class Message {
  final String message;
  final int userId;
  final DateTime timestamp;

  Message({
    required this.message,
    required this.userId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
