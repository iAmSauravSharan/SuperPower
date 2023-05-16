import 'package:superpower/bloc/payment/payment_bloc/model/payment.dart';

abstract class PaymentRepository {
  Future<Payment> getPaymentDetails();
}
