import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/util/app_state.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(initialState) : super(initialState) {
    on<ThemeEvent>((event, emit) async {
      if (event is ThemeChanged) {
        emit(ThemeState(themeManager: AppState.themeManager));
      }
    });
  }

  ThemeState get initialState =>
      ThemeState(themeManager: AppState.themeManager);
}
