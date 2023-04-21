import 'package:superpower/bloc/user/user_bloc/model/user.dart';

abstract class UserRepository {
  Future<User> getUser();
}
