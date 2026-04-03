part of 'referal_bloc.dart';

@immutable
abstract class ReferralState extends Equatable {
  const ReferralState();

  @override
  List<Object> get props => [];
}

class ReferralInitial extends ReferralState {}

class ReferralError extends ReferralState {
  final String message;

  const ReferralError(this.message);

  @override
  List<Object> get props => [message];
}

class ReferralCodeLoaded extends ReferralState {
  // Новое состояние
  final String referralCode;

  ReferralCodeLoaded(this.referralCode);
}
