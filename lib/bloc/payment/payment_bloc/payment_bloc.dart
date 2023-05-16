import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/payment_error.dart';
import 'package:superpower/bloc/payment/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc(this.paymentRepository) : super(Loading()) {
    on<PaymentEvent>((event, emit) async {
      emit(Loading());
      try {
        final data = await appEvent(event);
        emit(Loaded(data));
      } on PaymentError catch (e) {
        emit(LoadingFailed(e.toString()));
      } catch (e) {
        emit(LoadingFailed(e.toString()));
      }
    });
  }

  Future<dynamic> appEvent(PaymentEvent event) async {
    switch (event.runtimeType) {
      case GetPaymentDataEvent:
        return paymentRepository.getPaymentDetails();
      default:
        throw UnsupportedError('Unknown error occured');
    }
  }
}
