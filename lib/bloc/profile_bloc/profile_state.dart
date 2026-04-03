part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profileData;

  const ProfileLoaded(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ReferralCodeLoaded extends ProfileState {
  // Новое состояние
  final String referralCode;

  ReferralCodeLoaded(this.referralCode);
}
