part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Chat data;
  const ChatLoaded(this.data);
}

class ChatLoadingFailed extends ChatState {
  final String message;
  const ChatLoadingFailed(this.message);
}
