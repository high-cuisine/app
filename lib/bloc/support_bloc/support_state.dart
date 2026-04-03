part of 'support_bloc.dart';

@immutable
abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<Message> messages;

  const SupportLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class SupportError extends SupportState {
  final String message;

  const SupportError(this.message);

  @override
  List<Object> get props => [message];
}
