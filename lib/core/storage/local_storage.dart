import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool?> getBool(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool> remove(String key);
  Future<bool> clear();
}

class SharedPrefsStorage implements LocalStorage {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<String?> getString(String key) async {
    final instance = await prefs;
    return instance.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final instance = await prefs;
    return instance.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final instance = await prefs;
    return instance.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    final instance = await prefs;
    return instance.setBool(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    final instance = await prefs;
    return instance.remove(key);
  }

  @override
  Future<bool> clear() async {
    final instance = await prefs;
    return instance.clear();
  }
}
