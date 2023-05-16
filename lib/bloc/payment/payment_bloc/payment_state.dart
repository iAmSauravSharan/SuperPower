part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class Loading extends PaymentState {}

class Loaded extends PaymentState {
  final Object data;
  const Loaded(this.data);
}

class LoadingFailed extends PaymentState {
  final String message;
  const LoadingFailed(this.message);
}
