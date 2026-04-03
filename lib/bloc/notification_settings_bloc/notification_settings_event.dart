part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsEvent {}

class ToggleSmsNotificationEvent extends NotificationSettingsEvent {}

class TogglePushNotificationEvent extends NotificationSettingsEvent {}

class LoadNotificationSettingsEvent extends NotificationSettingsEvent {}
