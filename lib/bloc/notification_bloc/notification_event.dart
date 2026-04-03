part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationsAsRead extends NotificationEvent {}
