part of 'llm_bloc.dart';

abstract class LLMState extends Equatable {
  const LLMState();

  @override
  List<Object> get props => [];
}

class Updating extends LLMState {}

class Updated extends LLMState {
  final Object data;
  const Updated(this.data);
}

class UpdateFailed extends LLMState {
  final String message;
  const UpdateFailed(this.message);
}
