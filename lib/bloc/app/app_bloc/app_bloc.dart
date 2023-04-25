import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';
import 'package:superpower/bloc/app/app_bloc/model/app_error.dart';
import 'package:superpower/bloc/app/app_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository appRepository;

  AppBloc(this.appRepository) : super(AppLoading()) {
    on<AppEvent>((event, emit) async {
      emit(AppLoading());
      try {
        final data = await loadApp(event);
        emit(AppLoaded(data));
      } on AppError catch (e) {
        emit(AppLoadingFailed(e.toString()));
      } catch (e) {
        emit(AppLoadingFailed(e.toString()));
      }
    });
  }

  Future<AppPreference> loadApp(AppEvent event) async {
    switch (event.runtimeType) {
      case GetAppPreferenceEvent:
        return appRepository.getAppPreference();
      default:
        throw UnsupportedError('Unknown error occured');
    }
  }
}
