import 'package:superpower/bloc/theme/theme_constants.dart';

class UserPreference {
  final String _appTheme;
  final String _availableCredits;

  UserPreference([this._appTheme = system, this._availableCredits = "0"]);

  String getAppTheme() => _appTheme;
  String getAvailableCredits() => _availableCredits;

  Map<String, dynamic> toJson() =>
      {'app_theme': _appTheme.trim(), 'available_credits': _availableCredits.trim()};

  UserPreference.fromJson(Map<String, dynamic> json)
      : _appTheme = json['app_theme'],
        _availableCredits = json['available_credits'];
}
