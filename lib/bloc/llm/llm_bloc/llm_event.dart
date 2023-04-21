part of 'llm_bloc.dart';

abstract class LLMEvent extends Equatable {
  const LLMEvent();

  @override
  List<Object> get props => [];
}

class GetLLMPreferenceEvent extends LLMEvent {
  const GetLLMPreferenceEvent();
}

class GetLLMsEvent extends LLMEvent {
  const GetLLMsEvent();
}

class UpdateVendorEvent extends LLMEvent {
  final String vendor;
  const UpdateVendorEvent(this.vendor);
}

// class GetModelsEvent extends LLMEvent {
//   const GetModelsEvent();
// }

class UpdateModelEvent extends LLMEvent {
  final String model;
  const UpdateModelEvent(this.model);
}

// class GetCreativityLevelsEvent extends LLMEvent {
//   const GetCreativityLevelsEvent();
// }

class UpdateCreativityLevelEvent extends LLMEvent {
  final String creativityLevel;
  const UpdateCreativityLevelEvent(this.creativityLevel);
}

// class GetAccessKeyEvent extends LLMEvent {
//   const GetAccessKeyEvent();
// }

class UpdateAccessKeyEvent extends LLMEvent {
  final String accessKey;
  const UpdateAccessKeyEvent(this.accessKey);
}
