part of 'app_start_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppAuthenticated extends AppState {}

class AppUnauthenticated extends AppState {}
