part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatEvent extends ChatEvent {
  const GetChatEvent();
}

class GetChatPreferenceEvent extends ChatEvent {
  const GetChatPreferenceEvent();
}
