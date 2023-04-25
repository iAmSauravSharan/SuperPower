part of 'llm_bloc.dart';

abstract class LLMEvent extends Equatable {
  const LLMEvent();

  @override
  List<Object> get props => [];
}

class GetUserLLMPreferenceEvent extends LLMEvent {
  const GetUserLLMPreferenceEvent();
}

class GetLLMsEvent extends LLMEvent {
  const GetLLMsEvent();
}

class UpdateUserLLMPreferenceEvent extends LLMEvent {
  const UpdateUserLLMPreferenceEvent();
}

class UpdateVendorEvent extends LLMEvent {
  final String vendor;
  const UpdateVendorEvent(this.vendor);
}

class UpdateModelEvent extends LLMEvent {
  final String model;
  const UpdateModelEvent(this.model);
}

class UpdateCreativityLevelEvent extends LLMEvent {
  final String creativityLevel;
  const UpdateCreativityLevelEvent(this.creativityLevel);
}

class UpdateAccessKeyEvent extends LLMEvent {
  final Map<String, String> accessKeys;
  const UpdateAccessKeyEvent(this.accessKeys);
}
