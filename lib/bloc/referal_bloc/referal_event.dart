part of 'referal_bloc.dart';

@immutable
abstract class ReferralEvent extends Equatable {
  const ReferralEvent();

  @override
  List<Object> get props => [];
}

class FetchReferralCode extends ReferralEvent {}
