import 'dart:io';

import 'package:cocktails/options.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cocktail_auth_response_model.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppOptions.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<AuthResponse> signIn(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/web/sign-in/',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      print('Request sent: ${({'username': username, 'password': password})}');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', authResponse.token);
        print('Sign-in successful, token: ${authResponse.token}');
        return authResponse;
      } else if (response.statusCode == 400) {
        // Возвращаем сообщение об ошибке при коде 400
        print('Invalid credentials: ${response.data}');
        throw Exception('Неправильный логин или пароль');
      } else {
        print('Failed to sign in: ${response.statusCode}');
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during sign-in: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> verifyEmail(String email) async {
    try {
      final response = await _dio.post(
        '/auth/auth/verify-email/',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'X-CSRFToken':
                'EM7evcIdIKNImaIaITStWkxMiJcvfNopWcmppbnGkpEHUjYXZhybikeBpQTIA2yu',
          },
        ),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else {
        print('Failed to send verification email: ${response.statusCode}');
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      print('Error sending verification email: $e');
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<void> confirmCode(String email, String code) async {
    try {
      final response = await _dio.post(
        '/auth/auth/confirm-code/',
        data: {'email': email, 'code': code},
      );
      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else {
        print('Failed to send verification email: ${response.statusCode}');
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      throw Exception('Failed to confirm code: $e');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String dateOfBirth,
    required String password,
    required String email,
    String refCode = "", // Новый параметр для кода реферала
  }) async {
    try {
      print('Registering with data:');
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Phone: $phone');
      print('Gender: $gender');
      print('Date of Birth: $dateOfBirth');
      print('Password: $password');
      print('Email: $email');
      print('Ref Code: $refCode');

      // Определяем операционную систему
      final os = Platform.isAndroid ? "Android" : "ios";

      final response = await _dio.post(
        '/auth/auth/register/',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "gender": gender,
          "date_of_birth": dateOfBirth,
          "password": password,
          "email": email,
          "os": os, // Добавляем поле для операционной системы
          "ref_code": refCode, // Добавляем поле для кода реферала
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Registration successful');
      } else {
        print('Failed to register: ${response.statusCode}');
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/auth/password/reset/',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to request password reset');
      }
    } catch (e) {
      throw Exception('Error during password reset request: $e');
    }
  }

  // Метод для подтверждения кода сброса пароля
  Future<void> confirmPasswordResetCode(String email, String code) async {
    try {
      final response = await _dio.post(
        '/auth/password/reset-code/',
        data: {'email': email, 'code': code},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to confirm password reset code');
      }
    } catch (e) {
      throw Exception('Error during password reset code confirmation: $e');
    }
  }

  // Метод для установки нового пароля
  Future<void> resetPassword(String email, String newPassword,
      String repeatPassword, String code) async {
    try {
      final response = await _dio.post(
        '/auth/password/confirm/',
        data: {
          'email': email,
          'new_password': newPassword,
          'repeat_password': repeatPassword,
          'code': code,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Пароль изменен');
      } else {
        print('Ошибка изменения пароля: ${response.statusCode}');
        throw Exception('Ошибка изменения пароля');
      }
    } catch (e) {
      print('Ошибка во время сброса пароля: $e');
      throw Exception('Ошибка во время сброса пароля: $e');
    }
  }

  Future<AuthSocResponse?> sendTokensToServer(
      String idToken, String accessToken) async {
    try {
      final response = await _dio.post(
        '/auth/social/google/',
        data: {
          'id_token': idToken,
          'access_token': accessToken,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Google social auth status: ${response.statusCode}');
      print('Google social auth data: ${response.data}');

      final status = response.statusCode ?? 0;
      if (status != 200 && status != 201) {
        print('Ошибка при отправке токенов: $status');
        return null;
      }

      final data = response.data;
      if (data is! Map) {
        print('Unexpected response shape for social auth');
        return null;
      }

      // Some backends return token under different keys.
      final mapped = Map<String, dynamic>.from(data);
      mapped['token'] ??= mapped['key'] ?? mapped['auth_token'];

      if (mapped['token'] == null) {
        print('Social auth succeeded but token missing in response');
        return null;
      }

      return AuthSocResponse.fromJson(mapped);
    } catch (e) {
      print('Ошибка при отправке токенов на сервер: $e');
      return null;
    }
  }
}
