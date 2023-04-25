import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/auth_error.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/auth/auth_repository.dart';
import 'package:superpower/bloc/llm/llm_bloc/llm_bloc.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_error.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/bloc/user/user_repository.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/util.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserLoading()) {
    on<UserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final data = await loadUser(event);
        emit(UserLoaded(data));
      } on UserError catch (e) {
        emit(UserLoadingFailed(e.toString()));
      } catch (e) {
        emit(UserLoadingFailed(e.toString()));
      }
    });
  }

  Future<Object> loadUser(UserEvent event) async {
    switch (event.runtimeType) {
      case GetUserEvent:
        return userRepository.getUser();
      case GetUserPreferenceEvent:
        return userRepository.getUserPreference();
      case UpdateUserPreferenceEvent:
        return userRepository.updateUserPreference(
            (event as UpdateUserPreferenceEvent)._userPreference);
      default:
        throw UnsupportedError('Unknown error occured');
    }
  }
}
