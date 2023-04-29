class AuthError extends Error {
  final String message;

  AuthError(this.message);

  @override
  String toString() => message;
}
