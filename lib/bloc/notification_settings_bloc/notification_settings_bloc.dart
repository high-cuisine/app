import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  static const String _smsNotificationKey = 'sms_notifications';
  static const String _pushNotificationKey = 'push_notifications';

  NotificationSettingsBloc()
      : super(NotificationSettingsState(
          smsNotificationsEnabled: true,
          pushNotificationsEnabled: false,
        )) {
    on<ToggleSmsNotificationEvent>(_onToggleSmsNotification);
    on<TogglePushNotificationEvent>(_onTogglePushNotification);
    on<LoadNotificationSettingsEvent>(_onLoadNotificationSettings);
    add(LoadNotificationSettingsEvent()); // Load settings when bloc is created
  }

  Future<void> _onToggleSmsNotification(ToggleSmsNotificationEvent event,
      Emitter<NotificationSettingsState> emit) async {
    final newStatus = !state.smsNotificationsEnabled;
    emit(state.copyWith(smsNotificationsEnabled: newStatus));
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_smsNotificationKey, newStatus);
  }

  Future<void> _onTogglePushNotification(TogglePushNotificationEvent event,
      Emitter<NotificationSettingsState> emit) async {
    final newStatus = !state.pushNotificationsEnabled;
    emit(state.copyWith(pushNotificationsEnabled: newStatus));
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_pushNotificationKey, newStatus);
  }

  Future<void> _onLoadNotificationSettings(LoadNotificationSettingsEvent event,
      Emitter<NotificationSettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final smsNotificationsEnabled = prefs.getBool(_smsNotificationKey) ?? false;
    final pushNotificationsEnabled =
        prefs.getBool(_pushNotificationKey) ?? false;
    emit(state.copyWith(
      smsNotificationsEnabled: smsNotificationsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled,
    ));
  }
}
