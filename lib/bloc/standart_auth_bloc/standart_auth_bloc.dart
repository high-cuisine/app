import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cocktail_auth_response_model.dart';
import '../../provider/cocktail_auth_repository.dart';

part 'standart_auth_event.dart';
part 'standart_auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus); // Add new event handler
    on<SignOutRequested>(_onSignOutRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<ConfirmCodeRequested>(_onConfirmCodeRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<RequestPasswordReset>(_onRequestPasswordReset);
    on<ConfirmResetCode>(_onConfirmResetCode);
    on<ResetPassword>(_onResetPassword);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authResponse =
          await authRepository.signIn(event.username, event.password);
      emit(AuthAuthenticated(authResponse));
    } catch (e) {
      emit(AuthUnauthenticated());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('чек аунт активирован');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        final authResponse = AuthResponse(token: token);
        emit(AuthAuthenticated(authResponse));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyEmailRequested(
      VerifyEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.verifyEmail(event.email);
      emit(EmailVerified());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Подтверждение кода
  Future<void> _onConfirmCodeRequested(
      ConfirmCodeRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.confirmCode(event.email, event.code);
      emit(CodeConfirmed());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Регистрация пользователя
  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        password: event.password,
        email: event.email,
        refCode: event.refCode, // Передаём реферальный код
      );
      final authResponse =
          await authRepository.signIn(event.email, event.password);
      emit(AuthAuthenticated(authResponse));
      emit(UserRegistered());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRequestPasswordReset(
      RequestPasswordReset event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.requestPasswordReset(event.email);
      emit(PasswordResetRequested());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onConfirmResetCode(
      ConfirmResetCode event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.confirmPasswordResetCode(event.email, event.code);
      emit(PasswordResetCodeConfirmed());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(
        event.email,
        event.newPassword,
        event.repeatPassword,
        event.code,
      );
      final authResponse =
          await authRepository.signIn(event.email, event.newPassword);
      emit(AuthAuthenticated(authResponse));
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
      SignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthGoogleLoading());

    try {
      // Using `print` to ensure visibility in Android logcat/Flutter console.
      print('Google sign-in: start');

      // Web OAuth client id from `android/app/google-services.json` (client_type: 3)
      const webClientId =
          '461533428167-dvfbk4sga6ftgbi5uhhnou0hubmhbvtl.apps.googleusercontent.com';

      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in: cancelled (googleUser == null)');
        emit(AuthUnauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken != null && accessToken != null) {
        print('Google sign-in: tokens received');
        final authResponse =
            await AuthRepository().sendTokensToServer(idToken, accessToken);

        if (authResponse != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', authResponse.token);
          emit(AuthAuthenticated(AuthResponse(token: authResponse.token)));
        } else {
          emit(AuthGoogleError('Ошибка авторизации через Google.'));
        }
      } else {
        print(
          'Google sign-in: tokens missing. idToken: ${idToken != null}, accessToken: ${accessToken != null}',
        );
        emit(AuthGoogleError('Отсутствуют токены Google.'));
      }
    } catch (e, st) {
      print('Google sign-in: failed: $e');
      print(st);
      emit(AuthGoogleError(e.toString()));
    }
  }
}
