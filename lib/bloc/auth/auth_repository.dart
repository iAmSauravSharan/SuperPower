import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/ui/authentication_page/login_page.dart';

abstract class AuthenticationRepository {
  Future<Object> login(Login login);
  Future<Object> signup(Signup signup);
  Future<Object> confirmUser(VerifyCode verifyCode);
  Future<Object> sendCode(VerifyCode verifyCode);
  Future<Object> resetPassword(ResetPassword resetPassword);
  Future<Object> logout();
}
