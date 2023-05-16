import 'package:superpower/bloc/llm/llm_bloc/model/llm_model.dart';

class LLM {
  String _id;
  String _vendor;
  bool _isSelected = false;
  List<LLMModel> _models;
  String? _accessKey;

  LLM(this._id, this._vendor, this._models, this._accessKey, this._isSelected);

  String getId() => _id;

  setId(String id) => _id = id;

  bool isSelected() => _isSelected;

  updateSelectionStatus(bool status) => _isSelected = status;

  String getVendor() => _vendor;

  setVendor(String vendor) => _vendor = vendor;

  List<LLMModel> getModel() => _models;

  setModel(List<LLMModel> models) => _models = models;

  String getAccessKey() => _accessKey ?? '';

  setAccessKey(String accessKey) => _accessKey = accessKey;

  Map<String, dynamic> toJson() => {
        'vendor': _vendor,
        'models': _models.map((model) => model.toJson()).toList(),
        'id': _id,
        "isSelected": _isSelected,
        'accessKey': _accessKey
      };

  factory LLM.fromJson(Map<String, dynamic> json) {
    var modelsJson = json['models'] as List<dynamic>;
    var models =
        modelsJson.map((modelJson) => LLMModel.fromJson(modelJson)).toList();

    return LLM(
      json['id'],
      json['vendor'],
      models,
      json['accessKey'],
      json['isSelected'],
    );
  }
}
