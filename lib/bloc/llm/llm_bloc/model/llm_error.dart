class LLMError extends Error {
  final String message;

  LLMError(this.message);

  @override
  String toString() => message;
}
