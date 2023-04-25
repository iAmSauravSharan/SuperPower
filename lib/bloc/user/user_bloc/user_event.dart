part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvent {
  const GetUserEvent();
}

class GetUserPreferenceEvent extends UserEvent {
  const GetUserPreferenceEvent();
}

class UpdateUserPreferenceEvent extends UserEvent {
  final UserPreference _userPreference;
  const UpdateUserPreferenceEvent(this._userPreference);
}
