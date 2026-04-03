part of 'support_bloc.dart';

@immutable
abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object> get props => [];
}

class ConnectSupport extends SupportEvent {
  final int userId;

  const ConnectSupport(this.userId);
}

class SendMessage extends SupportEvent {
  final String message;

  const SendMessage(this.message);
}

class FetchChatHistory extends SupportEvent {}
