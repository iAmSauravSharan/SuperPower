import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';

abstract class UserRepository {
  Future<User> getUser();
  Future<UserPreference> getUserPreference();
  Future<Object> updateUserPreference(UserPreference userPreference);
}
