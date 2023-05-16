import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/bloc/llm/llm_bloc/llm_bloc.dart';
import 'package:superpower/bloc/payment/payment_bloc/payment_bloc.dart';
import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/bloc/user/user_bloc/user_bloc.dart';
import 'package:superpower/bloc/chat/chat_bloc/chat_bloc.dart';
import 'package:superpower/bloc/app/app_bloc/app_bloc.dart';
import 'package:superpower/data/data_repository.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('AppState');

class AppState {
  static DataRepository repository = DataRepository();

  static ThemeManager themeManager = ThemeManager();

  static AuthenticationBloc authenticationBloc = AuthenticationBloc(repository);
  static LLMBloc llmBloc = LLMBloc(repository);
  static UserBloc userBloc = UserBloc(repository);
  static ChatBloc chatBloc = ChatBloc(repository);
  static AppBloc appBloc = AppBloc(repository);
  static PaymentBloc paymentBloc = PaymentBloc(repository);

  static bool isProd = false;

  static void initialize() {
    log.d('started initializing AppState');
    repository;
    themeManager;
    log.d('finished initializing AppState');
  }
}
