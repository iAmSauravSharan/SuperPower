import 'package:equatable/equatable.dart';

class LLMCreativity extends Equatable {
  final String _id;
  final String _name;
  bool _isSelected = false;

  LLMCreativity(this._id, this._name, this._isSelected);

  String getId() => _id;
  String getName() => _name;

  bool isSelected() => _isSelected;
  updateSelectionStatus(bool status) => _isSelected = status;

  @override
  List<Object?> get props => [_name];

  Map<String, dynamic> toJson() =>
      {'name': _name, 'id': _id, 'isSelected': _isSelected};

  LLMCreativity.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _isSelected = json['isSelected'],
        _id = json['id'];
}
