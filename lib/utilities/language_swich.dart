import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'user_language';

  static String _currentLanguage = 'rus';

  /// Синхронный доступ к текущему языку (из in-memory кэша).
  static String get currentLanguage => _currentLanguage;

  static Future<void> saveLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'rus';
    return _currentLanguage;
  }

  /// Однократная миграция: если easy_localization сохранил локаль,
  /// а LanguageService ещё не синхронизирован — обновляем.
  static Future<void> syncFromEasyLocalization() async {
    final prefs = await SharedPreferences.getInstance();
    final easyLocale = prefs.getString('locale');
    if (easyLocale != null && easyLocale.isNotEmpty) {
      final lang = easyLocale.startsWith('ru') ? 'rus' : 'eng';
      if (lang != _currentLanguage) {
        await saveLanguage(lang);
      }
    }
  }
}
