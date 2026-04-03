import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../provider/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    Map<String, dynamic>? cachedProfile;
    try {
      cachedProfile = await repository.getProfileFromCache();
      if (cachedProfile != null) {
        emit(ProfileLoaded(cachedProfile));
      }

      final profileData =
          await repository.fetchProfileDataFromServer(forceRefresh: true);
      emit(ProfileLoaded(profileData));
    } catch (e) {
      print('Ошибка при загрузке профиля: $e');
      if (cachedProfile != null) {
        emit(ProfileLoaded(cachedProfile));
      } else {
        emit(ProfileError('Failed to fetch profile: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profileData = await repository.updateProfile(event.data);
      emit(ProfileLoaded(profileData));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }
}
