import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/data/preference_manager.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final log = Logging('ThemeManager');

  ThemeManager() {
    log.d('Theme manager initialization started');
    PreferanceManager.readData(PrefConstant.themeMode).then((value) {
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
    PreferanceManager.saveData(PrefConstant.themeMode, themeMode.name);
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    log.d('dark theme set');
    PreferanceManager.saveData(PrefConstant.themeMode, ThemeMode.dark.name);
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    log.d('light theme set');
    PreferanceManager.saveData(PrefConstant.themeMode, ThemeMode.light.name);
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    log.d('system theme set');
    PreferanceManager.saveData(PrefConstant.themeMode, ThemeMode.system.name);
  }

  ThemeMode getTheme() => _themeMode;
}
