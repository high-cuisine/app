import 'dart:convert';

import 'package:cocktails/options.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppOptions.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Функция для получения токена из SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Функция для сохранения профиля в SharedPreferences
  Future<void> saveProfileToCache(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', jsonEncode(profileData));
  }

  // Функция для загрузки профиля из SharedPreferences
  Future<Map<String, dynamic>?> getProfileFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileString = prefs.getString('profile');
    if (profileString != null) {
      return jsonDecode(profileString) as Map<String, dynamic>;
    }
    return null;
  }

  // Функция для загрузки профиля с сервера
  Future<Map<String, dynamic>> fetchProfileDataFromServer(
      {bool forceRefresh = false}) async {
    try {
      final cachedProfile = await getProfileFromCache();
      if (cachedProfile != null && !forceRefresh) {
        // Возвращаем кэшированные данные сразу
        return cachedProfile;
      }

      // Загружаем данные с сервера
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await dio.get(
        '/profile/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data as Map<String, dynamic>;

        // Сохраняем загруженные данные в кэш
        await saveProfileToCache(profileData);

        return profileData;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  Future<String> fetchReferralCode() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await dio.get(
        '/profile/referral/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );
      print(response.toString());
      if (response.statusCode == 200) {
        // Теперь ожидаем, что ответ имеет формат: {"code": "TsWKV6Oqgq6k"}
        final referralCode = response.data['code'];
        return referralCode;
      } else {
        throw Exception('Failed to load referral code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching referral code: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await dio.patch(
        '/profile/',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data as Map<String, dynamic>;
        await saveProfileToCache(profileData);
        return profileData;
      }

      throw Exception('Failed to update profile: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}
