import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> storingTheme(String theme) async {
    await _prefs?.setString("theme", theme);
  }

  static Future<String?> retrieveTheme() async {
    return _prefs?.getString("theme");
  }

  static Future<void> removeTheme() async {
    await _prefs?.remove("theme");
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
