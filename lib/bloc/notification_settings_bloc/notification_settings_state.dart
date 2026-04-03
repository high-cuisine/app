part of 'notification_settings_bloc.dart';

@immutable
class NotificationSettingsState {
  final bool smsNotificationsEnabled;
  final bool pushNotificationsEnabled;

  const NotificationSettingsState({
    required this.smsNotificationsEnabled,
    required this.pushNotificationsEnabled,
  });

  NotificationSettingsState copyWith({
    bool? smsNotificationsEnabled,
    bool? pushNotificationsEnabled,
  }) {
    return NotificationSettingsState(
      smsNotificationsEnabled:
          smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}
