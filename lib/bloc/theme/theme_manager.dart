import 'package:flutter/material.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('ThemeManager');

class ThemeManager with ChangeNotifier {
  static ThemeManager? instance;

  ThemeMode _themeMode = ThemeMode.system;
  final _repository = AppState.repository;

  ThemeManager._() {
    log.d('Theme manager initialization started');
    _repository.getUserPreference().then((userPreference) {
      final value = userPreference.getAppTheme();
      log.d('value read from storage: $value');
      final theme = value ?? ThemeMode.system.name;
      final storedTheme = getThemeModeFrom(theme);
      if (storedTheme != _themeMode) {
        log.d(
            "theme has been changed from $_themeMode -> $storedTheme. Updating theme..");
        _themeMode = storedTheme;
      }
    });
    log.d('Theme manager initialized');
  }

  ThemeMode getThemeModeFrom(String theme) {
    if (theme == ThemeMode.dark.name) return ThemeMode.dark;
    if (theme == ThemeMode.light.name) return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme(ThemeMode themeMode) {
    log.d('toggling theme');
    _themeMode = themeMode;
    _repository.saveTheme(PrefConstant.themeMode, themeMode.name);
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    log.d('dark theme set');
    _repository.saveTheme(PrefConstant.themeMode, ThemeMode.dark.name);
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    log.d('light theme set');
    _repository.saveTheme(PrefConstant.themeMode, ThemeMode.light.name);
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    log.d('system theme set');
    _repository.saveTheme(PrefConstant.themeMode, ThemeMode.system.name);
  }

  ThemeMode getTheme() => _themeMode;

  factory ThemeManager() => instance ??= ThemeManager._();
}
