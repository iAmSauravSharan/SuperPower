class UserError extends Error {
  final String message;

  UserError(this.message);

  @override
  String toString() => message;
}
