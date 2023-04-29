part of 'app_bloc.dart';

abstract class AppsState extends Equatable {
  const AppsState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AppsState {}

class AppLoaded extends AppsState {
  final Object data;
  const AppLoaded(this.data);
}

class AppLoadingFailed extends AppsState {
  final String message;
  const AppLoadingFailed(this.message);
}
