class PaymentError extends Error {
  final String message;

  PaymentError(this.message);

  @override
  String toString() => message;
}
