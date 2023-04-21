import 'package:superpower/util/constants.dart';

abstract class CacheRepository {
  Future<bool> isLogin();
  Future<bool> initialAppLaunch();
  void setAppLaunchStatus(bool status);
  void saveToken(TokenType tokenType, String token);
  void setLoggedinStatus(bool isLoggedIn);
  Future<String> getToken(TokenType tokenType);
  Future<void> clear();
}
