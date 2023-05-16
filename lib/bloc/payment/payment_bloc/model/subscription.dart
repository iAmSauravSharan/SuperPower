import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final int id;
  final String name;
  final String price;
  final String refererText;
  final List<String> benefits;

  const Subscription(this.id, this.name, this.price, this.refererText, this.benefits);

  int getId() => id;
  List<String> getBenefits() => benefits;
  String getName() => name;
  String getRefererText() => refererText;
  String getPrice() => price;

  factory Subscription.fromJson(Map<String, dynamic> json) {
    final benefitsJson = json['benefits'] as List<dynamic>;
    final benefits =
        benefitsJson.map((benefitJson) => benefitJson as String).toList();
    return Subscription(
      json['id'] as int,
      json['name'] as String,
      json['price'] as String,
      json['refererText'] as String,
      benefits,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'refererText': refererText,
      'benefits': benefits,
    };
  }

  @override
  List<Object?> get props => [id];
}
