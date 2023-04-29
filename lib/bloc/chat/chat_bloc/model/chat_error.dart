class ChatError extends Error {
  final String message;

  ChatError(this.message);

  @override
  String toString() => message;
}
