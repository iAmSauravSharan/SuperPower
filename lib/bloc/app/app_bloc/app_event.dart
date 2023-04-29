part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetAppPreferenceEvent extends AppEvent {
  const GetAppPreferenceEvent();
}

class GetAppFAQEvent extends AppEvent {
  const GetAppFAQEvent();
}

class SubmitFeedbackEvent extends AppEvent {
  final double rating;
  final String feedback;
  const SubmitFeedbackEvent(this.rating, this.feedback);
}
