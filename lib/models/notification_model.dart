class NotificationItem {
  final int id;
  final String topik;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.topik,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      topik: json['topik'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
