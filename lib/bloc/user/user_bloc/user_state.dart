part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Object data;
  const UserLoaded(this.data);
}

class UserLoadingFailed extends UserState {
  final String message;
  const UserLoadingFailed(this.message);
}
