part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  final ThemeMode themeMode;
  const ThemeEvent(this.themeMode);
}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  const ThemeChanged({required this.themeMode}) : super(themeMode);
}
