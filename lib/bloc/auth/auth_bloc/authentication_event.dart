part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LogoutEvent extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String username;
  final String password;
  const LoginEvent(this.username, this.password);
}

class SignupEvent extends AuthenticationEvent {
  final String username;
  final String email;
  final String password;
  const SignupEvent(this.username, this.email, this.password);
}

class SendCodeEvent extends AuthenticationEvent {
  final String email;
  const SendCodeEvent(this.email);
}

class VerifyCodeEvent extends AuthenticationEvent {
  final String username;
  final String code;
  const VerifyCodeEvent(this.username, this.code);
}

class ResetPasswordEvent extends AuthenticationEvent {
  final String username;
  final String password;
  final String code;
  const ResetPasswordEvent(this.username, this.password, this.code);
}
