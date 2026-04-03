import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/cocktail_auth_repository.dart';

part 'app_start_event.dart';
part 'app_start_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;

  AppBloc(this.authRepository) : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final isFirstLaunch = await _checkFirstLaunch();
    if (!isFirstLaunch) {
      emit(AppAuthenticated());
    } else {
      final isAuthenticated = await _checkAuthStatus();
      emit(isAuthenticated ? AppAuthenticated() : AppUnauthenticated());
    }
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
    return isFirstLaunch;
  }

  Future<bool> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }
}
