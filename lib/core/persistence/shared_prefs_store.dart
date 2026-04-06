import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class SharedPrefsStore implements KeyValueStore {
  final SharedPreferences _prefs;

  SharedPrefsStore(this._prefs);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
