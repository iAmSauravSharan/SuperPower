import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superpower/bloc/chat/chat_bloc/model/chat.dart';
import 'package:superpower/bloc/chat/chat_repository.dart';
import 'package:superpower/bloc/chat/chat_bloc/model/chat_error.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatLoading()) {
    on<ChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final data = await loadChat(event);
        emit(ChatLoaded(data));
      } on ChatError catch (e) {
        emit(ChatLoadingFailed(e.toString()));
      } catch (e) {
        emit(ChatLoadingFailed(e.toString()));
      }
    });
  }

  Future<Chat> loadChat(ChatEvent event) async {
    switch (event.runtimeType) {
      case GetChatEvent:
        return chatRepository.getChat();
      case GetChatPreferenceEvent:
        return chatRepository.getChatPreference();
      default:
        throw UnsupportedError('Unknown error occured');
    }
  }
}
