part of 'standart_auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class EmailVerified extends AuthState {}

class UserRegistered extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class CodeConfirmed extends AuthState {}

class PasswordResetRequested extends AuthState {}

class PasswordResetCodeConfirmed extends AuthState {}

class PasswordResetSuccess extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthResponse authResponse;

  AuthAuthenticated(this.authResponse);

  @override
  List<Object> get props => [authResponse];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthGoogleLoading extends AuthState {}

class AuthGoogleError extends AuthState {
  final String message;

  AuthGoogleError(this.message);

  @override
  List<Object> get props => [message];
}
