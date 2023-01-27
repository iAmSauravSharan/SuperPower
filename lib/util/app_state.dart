import 'dart:async';

import 'package:superpower/data/repository.dart';
import 'package:superpower/util/theme/theme_manager.dart';

class AppState {
  static Repository? _repository;
  static ThemeManager? _themeManager;

  static Repository? getRespository() {
    _repository ??= Repository(StreamController());
    return _repository;
  }

  static ThemeManager getThemeManager() {
    _themeManager ??= ThemeManager();
    return _themeManager!;
  }
}
