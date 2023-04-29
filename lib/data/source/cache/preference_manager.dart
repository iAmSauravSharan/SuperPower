import 'package:shared_preferences/shared_preferences.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('PreferenceManager');

class PreferenceManager {
  static PreferenceManager? instance;
  late SharedPreferences _sharedPreference;

  PreferenceManager._() {
    log.d("initializing preference manager..");
    // init();
    log.d("initialized preference manager..");
  }

  factory PreferenceManager() => instance ??= PreferenceManager._();

  init() async {
    log.d("initializing shared preference..");
    _sharedPreference = await SharedPreferences.getInstance();
    log.d("initializing shared preference..");
  }

  void save(String key, dynamic value) async {
    _sharedPreference = await SharedPreferences.getInstance();
    if (value is int) {
      _sharedPreference.setInt(key, value);
    } else if (value is String) {
      _sharedPreference.setString(key, value);
    } else if (value is bool) {
      _sharedPreference.setBool(key, value);
    } else if (value is double) {
      _sharedPreference.setDouble(key, value);
    }
  }

  void saveList(String key, List<String> value) async {
    _sharedPreference = await SharedPreferences.getInstance();
    _sharedPreference.setStringList(key, value);
  }

  Future<dynamic>? read(String key) async {
    _sharedPreference = await SharedPreferences.getInstance();
    if (!_sharedPreference.containsKey(key)) return null;
    dynamic obj = _sharedPreference.get(key);
    return obj;
  }

  Future<dynamic>? readList(String key) async {
    _sharedPreference = await SharedPreferences.getInstance();
    if (!_sharedPreference.containsKey(key)) return null;
    dynamic obj = _sharedPreference.getStringList(key);
    return obj;
  }

  Future<bool> delete(String key) async {
    _sharedPreference = await SharedPreferences.getInstance();
    if (!_sharedPreference.containsKey(key)) return false;
    return _sharedPreference.remove(key);
  }

  Future<bool> containsKey(String key) async {
    _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference.containsKey(key);
  }
}
