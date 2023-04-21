import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/bloc/llm/llm_bloc/llm_bloc.dart';
import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/bloc/user/user_bloc/user_bloc.dart';
import 'package:superpower/data/repository.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('AppState');

class AppState {
  static Repository repository = Repository();

  static ThemeManager themeManager = ThemeManager();

  static AuthenticationBloc authenticationBloc = AuthenticationBloc(repository);
  static LLMBloc llmBloc = LLMBloc(repository);
  static UserBloc userBloc = UserBloc(repository);

  static void initialize() {
    log.d('started initializing AppState');
    repository;
    themeManager;
    log.d('finished initializing AppState');
  }
}
