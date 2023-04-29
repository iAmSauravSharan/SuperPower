import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';

abstract class AuthenticationRepository {
  Future<Object> login(Login login);
  Future<Object> signup(Signup signup);
  Future<Object> confirmUser(VerifyCode verifyCode);
  Future<Object> sendCode(VerifyCode verifyCode);
  Future<Object> resetPassword(ResetPassword resetPassword);
  Future<Object> refreshToken(String token);
  Future<Object> logout();
}
