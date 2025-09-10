import '../shared_preferences_helper.dart';

class LocalizationCacheHelper {
  static Future<String> getLanguageCode() async {
    String? lang = await PreferenceManager.getInstance()!.getString('lang');
    return lang ?? 'en';
  }

  static Future<void> setLanguageCode(String languageCode) async {
    PreferenceManager.getInstance()!.saveString('lang', languageCode);
  }
}
