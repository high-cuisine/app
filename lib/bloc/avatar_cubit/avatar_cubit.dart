import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'avatar_state.dart';

class ProfileImageCubit extends Cubit<String?> {
  ProfileImageCubit() : super(null);

  // Загрузка изображения из SharedPreferences
  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    emit(imagePath); // Обновляем состояние с путем к изображению
  }

  // Установка и сохранение нового изображения
  Future<void> setProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
    emit(path); // Обновляем состояние с новым путем к изображению
  }
}
