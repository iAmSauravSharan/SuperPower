import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/auth_error.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/auth/auth_repository.dart';
import 'package:superpower/util/util.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authRepository;

  AuthenticationBloc(this.authRepository) : super(Unauthenticated()) {
    on<AuthenticationEvent>((event, emit) async {
      emit(Authenticating());
      try {
        final data = await authenticate(event);
        emit(Authenticated(data));
      } on AuthError catch (e) {
        emit(AuthenticationFailed(e.toString()));
      } catch (e) {
        emit(AuthenticationFailed(e.toString()));
      }
    });
  }

  Future<Object> authenticate(AuthenticationEvent event) async {
    switch (event.runtimeType) {
      case LoginEvent:
        String ipAddress = await getIpAddress();
        return authRepository.login(Login(
            (event as LoginEvent).username,
            (event).password,
            ipAddress,
            getCurrentTimestamp().toString(),
            getDeviceType()));
      case SignupEvent:
        String ipAddress = await getIpAddress();
        return authRepository.signup(Signup(
            (event as SignupEvent).username,
            (event).email,
            (event).password,
            ipAddress,
            getCurrentTimestamp().toString(),
            getDeviceType()));
      case SendCodeEvent:
        String ipAddress = await getIpAddress();
        return authRepository.sendCode(VerifyCode(
            (event as SendCodeEvent).username,
            '',
            '',
            '',
            ipAddress,
            getDeviceType()));
      case VerifyCodeEvent:
        String ipAddress = await getIpAddress();
        return authRepository.verifyCode(VerifyCode(
            (event as VerifyCodeEvent).username,
            (event).code,
            '',
            '',
            ipAddress,
            getDeviceType()));
      case ResetPasswordEvent:
        String ipAddress = await getIpAddress();
        return authRepository.resetPassword(ResetPassword(
            (event as ResetPasswordEvent).username,
            (event).password,
            ipAddress,
            getDeviceType()));
      default:
        throw UnsupportedError('Unknown error occured');
    }
  }
}
