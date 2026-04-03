part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileDym extends ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;

  const UpdateProfile(this.data);

  @override
  List<Object> get props => [data];
}
