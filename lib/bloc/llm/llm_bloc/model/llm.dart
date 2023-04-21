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
        'models': _models,
        'id': _id,
        "isSelected": _isSelected,
        'accessKey': _accessKey
      };

  LLM.fromJson(Map<String, dynamic> json)
      : _vendor = json['vendor'],
        _models = json['models'],
        _id = json['id'],
        _isSelected = json['isSelected'],
        _accessKey = json['accessKey'];
}
