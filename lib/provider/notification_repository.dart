import 'package:cocktails/provider/dio_service.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  final DioService dio = DioService();

  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final response = await dio.dio.get('/notification/');
      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((item) => NotificationItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await dio.dio.post('/notification/read/');

      if (response.statusCode == 200) {
        print('Notifications marked as read.');
      } else if (response.statusCode == 404) {
        // Обработка ошибки 404: нет непрочитанных уведомлений
        print('No unread notifications found.');
      } else {
        throw Exception('Failed to mark notifications as read');
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
      // Можно вывести лог или отправить сообщение пользователю в случае ошибки
    }
  }
}
