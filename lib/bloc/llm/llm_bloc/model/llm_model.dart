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
        'id': _id,
        'name': _name,
        'isSelected': _isSelected,
        'creativityLevel': _creativityLevel
            .map((creativityLevel) => creativityLevel.toJson())
            .toList(),
      };

  factory LLMModel.fromJson(Map<String, dynamic> json) {
    var creativityJson = json['creativityLevel'] as List<dynamic>;
    var creativityLevel = creativityJson
        .map((creativity) => LLMCreativity.fromJson(creativity))
        .toList();

    return LLMModel(
      json['id'],
      json['name'],
      creativityLevel,
      json['isSelected'],
    );
  }
}
