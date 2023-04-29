import 'package:equatable/equatable.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_creativity.dart';

class LLMModel extends Equatable {
  final String _id;
  final String _name;
  bool _isSelected = false;
  final List<LLMCreativity> _creativityLevel;

  LLMModel(this._id, this._name, this._creativityLevel, this._isSelected);

  String getId() => _id;
  String getName() => _name;

  bool isSelected() => _isSelected;
  updateSelectionStatus(bool status) => _isSelected = status;

  List<LLMCreativity> getCreativityLevels() => _creativityLevel;

  @override
  List<Object?> get props => [_isSelected];

  Map<String, dynamic> toJson() => {
        'name': _name,
        'id': _id,
        'isSelected': _isSelected,
        'creativityLevel': _creativityLevel
      };

  LLMModel.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _creativityLevel = json['creativityLevel'],
        _id = json['id'],
        _isSelected = json['isSelected'];
}
