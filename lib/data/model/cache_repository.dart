import 'package:superpower/util/constants.dart';

abstract class CacheRepository {
  Future<bool> isLoggedIn();
  Future<bool> isInitialAppLaunch();
  void setAppLaunchStatus(bool status);
  void saveToken(TokenType tokenType, String token);
  void saveTheme(String themeType, String theme);
  void setLoggedInStatus(bool isLoggedIn);
  Future<String> getToken(TokenType tokenType);
  Future<void> clear();
}
