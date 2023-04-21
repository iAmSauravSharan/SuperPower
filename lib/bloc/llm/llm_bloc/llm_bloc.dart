import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_error.dart';
import 'package:superpower/bloc/llm/llm_repository.dart';

part 'llm_event.dart';
part 'llm_state.dart';

class LLMBloc extends Bloc<LLMEvent, LLMState> {
  final LLMRepository llmRepository;

  LLMBloc(this.llmRepository) : super(Updating()) {
    on<LLMEvent>((event, emit) async {
      emit(Updating());
      try {
        final data = await update(event);
        emit(Updated(data));
      } on LLMError catch (e) {
        emit(UpdateFailed(e.toString()));
      } catch (e) {
        emit(UpdateFailed(e.toString()));
      }
    });
  }

  Future<Object> update(LLMEvent event) async {
    switch (event.runtimeType) {
      case GetLLMPreferenceEvent:
        return llmRepository.getUserLLMPreference();
      case GetLLMsEvent:
        return llmRepository.getLLMs();
      // case GetAccessKeyEvent:
      //   return llmRepository.getAccessKey();
      case UpdateVendorEvent:
        return llmRepository.updateVendor((event as UpdateVendorEvent).vendor);
      case UpdateModelEvent:
        return llmRepository.updateModel((event as UpdateModelEvent).model);
      case UpdateCreativityLevelEvent:
        return llmRepository.updateCretivityLevel(
            (event as UpdateCreativityLevelEvent).creativityLevel);
      case UpdateAccessKeyEvent:
        return llmRepository
            .updateAccessKey((event as UpdateAccessKeyEvent).accessKey);
      default:
        throw LLMError('Unknown error occured');
    }
  }
}
