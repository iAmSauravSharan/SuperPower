import 'package:superpower/bloc/chat/chat_bloc/model/chat.dart';

abstract class ChatRepository {
  Future<Chat> getChat();
  Future<Chat> getChatPreference();
}
