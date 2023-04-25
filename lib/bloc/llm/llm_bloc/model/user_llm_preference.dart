import 'package:equatable/equatable.dart';

class UserLLMPreference {
  String _id;
  String _vendorId;
  String _modelId;
  String _creativityLevelId;
  Map<String, String>? _accessKeys;

  UserLLMPreference(
      [this._id = "1",
      this._vendorId = "1",
      this._modelId = "1",
      this._accessKeys,
      this._creativityLevelId = "1"]);

  String getId() => _id;

  setId(String id) => _id = id;

  String getCreativityLevel() => _creativityLevelId;

  setCreativityLevel(String id) => _creativityLevelId = id;

  String getVendor() => _vendorId;

  setVendor(String vendor) => _vendorId = vendor;

  String getModel() => _modelId;

  setModel(String models) => _modelId = models;

  Map<String, String> getAccessKey() => _accessKeys ?? <String, String>{};

  setAccessKey(Map<String, String>? accessKeys) => _accessKeys = accessKeys;

  Map<String, dynamic> toJson() => {
        'vendor': _vendorId,
        'models': _modelId,
        'id': _id,
        "creativityLevelId": _creativityLevelId,
        'accessKey': _accessKeys
      };

  UserLLMPreference.fromJson(Map<String, dynamic> json)
      : _vendorId = json['vendor'],
        _modelId = json['models'],
        _id = json['id'],
        _creativityLevelId = json['creativityLevelId'],
        _accessKeys = json['accessKey'];
}
