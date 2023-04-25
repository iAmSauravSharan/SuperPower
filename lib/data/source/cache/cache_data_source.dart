import 'dart:convert';

import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';
import 'package:superpower/bloc/chat/chat_bloc/model/chat.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/user_llm_preference.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/data/source/cache/preference_manager.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('CacheDataSource');

class CacheDataSource {
  late PreferenceManager _preference;

  CacheDataSource() {
    _preference = PreferenceManager();
  }

  Future<bool> isLoggedIn() async {
    if (await _preference.containsKey(PrefConstant.loggedInStatus)) {
      return _preference.read(PrefConstant.loggedInStatus)
          as Future<bool>;
    }
    return Future.value(false);
  }

  void setLoggedInStatus(bool isLoggedIn) {
    return _preference.save(PrefConstant.loggedInStatus, isLoggedIn);
  }

  Future<String> getToken(TokenType type) {
    return _preference.read(type.name) as Future<String>;
  }

  Future<bool> isInitialAppLaunch() async {
    if (await _preference.containsKey(PrefConstant.initialLaunch)) {
      return await _preference.read(PrefConstant.initialLaunch) as Future<bool>;
    }
    return Future.value(true);
  }

  void setAppLaunchStatus(bool status) {
    _preference.save(PrefConstant.initialLaunch, status);
  }

  void saveToken(TokenType tokenType, String token) {
    _preference.save(tokenType.name, token);
  }

  void clear() {
    _preference.delete(TokenType.accessToken.name);
    _preference.delete(TokenType.idToken.name);
    _preference.delete(TokenType.refreshToken.name);
    _preference.save(PrefConstant.loggedInStatus, false);
  }

  void updateUserPreference(UserPreference userPreference) {
    _preference.save(
        PrefConstant.userPreference, jsonEncode(userPreference.toJson()));
  }

  Future<Chat>? getChatPreference() async {
    final data = await _preference.read(PrefConstant.chatPreference);
    if (data == null) return data;
    final json = jsonDecode(data) as Map<String, dynamic>;
    return Chat.fromJson(json);
  }

  Future<AppPreference>? getAppPreference() async {
    final data = await _preference.read(PrefConstant.appPreference);
    if (data == null) return data;
    final json = jsonDecode(data) as Map<String, dynamic>;
    return AppPreference.fromJson(json);
  }

  Future<UserPreference>? getUserPreference() async {
    final data = await _preference.read(PrefConstant.userPreference);
    if (data == null) return data;
    final json = jsonDecode(data) as Map<String, dynamic>;
    return UserPreference.fromJson(json);
  }

  Future<String>? getLLMAccessKeys() {
    return _preference.read(PrefConstant.userLLMAccessKeys) as Future<String>?;
  }

  Future<String>? getLLMModel() {
    return _preference.read(PrefConstant.userLLMModel) as Future<String>?;
  }

  Future<String>? getLLMVendor() {
    return _preference.read(PrefConstant.userLLMVendor) as Future<String>?;
  }

  Future<String>? getLLMCreativityLevel() {
    return _preference.read(PrefConstant.userLLMCreativityLevel)
        as Future<String>?;
  }

  void setLLMAccessKeys(Map<String, String> accessKeys) {
    return _preference.save(
        PrefConstant.userLLMAccessKeys, jsonEncode(accessKeys));
  }

  void setLLMModel(String modelId) {
    return _preference.save(PrefConstant.userLLMModel, modelId);
  }

  void setLLMVendor(String vendorId) {
    return _preference.save(PrefConstant.userLLMVendor, vendorId);
  }

  void setLLMCreativityLevel(String creativityLevelId) {
    return _preference.save(
        PrefConstant.userLLMCreativityLevel, creativityLevelId);
  }

  Future<UserLLMPreference>? getUserLLMPreference() async {
    final data = await _preference.read(PrefConstant.userLLMPreference);
    if (data == null) return data;
    log.d('preference data is available $data');
    Map<String, dynamic> preference = jsonDecode(data);
    final userLlmPreference = UserLLMPreference("1", preference["vendor"],
        preference["models"], null, preference["creativityLevelId"]);
    Map<String, String> accessKeys = Map<String, String>.from(
        preference['accessKey']
            .map((key, value) => MapEntry(key, value.toString())));
    userLlmPreference.setAccessKey(accessKeys);
    return Future.value(userLlmPreference);
  }

  void saveTheme(String themeType, String theme) {
    _preference.save(themeType, theme);
  }

  void updateUserLLMPreference(UserLLMPreference userLLMPreference) {
    _preference.save(
        PrefConstant.userLLMPreference, jsonEncode(userLLMPreference.toJson()));
  }

  void updateAppPreference(AppPreference appPreference) {
    _preference.save(
        PrefConstant.appPreference, jsonEncode(appPreference.toJson()));
  }
}
