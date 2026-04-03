import 'package:cocktails/options.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/language_swich.dart';

class DioService {
  late Dio dio;

  DioService() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppOptions.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Добавляем интерсептор для автоматического добавления токена и языка
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        options.headers['User-Language'] = LanguageService.currentLanguage;
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options); // Продолжаем с обновленными опциями
      },
      onResponse: (response, handler) {
        // Обработка ответа
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Обработка ошибок
        return handler.next(e);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
