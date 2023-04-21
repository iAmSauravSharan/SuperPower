import 'package:equatable/equatable.dart';

class LLMData extends Equatable {
  final String _id;
  final String _name;

  const LLMData(this._id, this._name);

  String getId() => _id;
  String getName() => _name;

  @override
  List<Object?> get props => [_name];
}
