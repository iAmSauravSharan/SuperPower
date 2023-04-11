part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {}

class Authenticating extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final Object data;
  const Authenticated(this.data);
}

class AuthenticationFailed extends AuthenticationState {
  final String message;
  const AuthenticationFailed(this.message);
}
