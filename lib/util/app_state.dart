import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/data/repository.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('AppState');

class AppState {
  static Repository repository = Repository();

  static ThemeManager themeManager = ThemeManager();

  static void initialize() {
    log.d('started initializing AppState');
    repository;
    themeManager;
    log.d('finished initializing AppState');
  }
}
