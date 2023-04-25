part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final Object data;
  const AppLoaded(this.data);
}

class AppLoadingFailed extends AppState {
  final String message;
  const AppLoadingFailed(this.message);
}
