import 'package:equatable/equatable.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/subscription.dart';

class Payment extends Equatable {
  final String _title;
  final String _description;
  final List<Subscription> _subscriptions;

  const Payment(this._title, this._description, this._subscriptions);

  String getTitle() => _title;
  String getContent() => _description;
  List<Subscription> getSubscriptions() => _subscriptions;

  @override
  List<Object> get props => [_title, _description, _subscriptions];

  factory Payment.fromJson(Map<String, dynamic> json) {
    final subscriptionsJson = json['subscriptions'] as List<dynamic>;
    final subscriptions = subscriptionsJson
        .map((subscriptionJson) => Subscription.fromJson(subscriptionJson))
        .toList();
    return Payment(
      json['title'] as String,
      json['description'] as String,
      subscriptions,
    );
  }

  Map<String, dynamic> toJson() {
    final subscriptionsJson =
        _subscriptions.map((subscription) => subscription.toJson()).toList();
    return {
      'title': _title,
      'description': _description,
      'subscriptions': subscriptionsJson,
    };
  }

  @override
  String toString() => toJson().toString();
}
