import 'dart:convert';

class Messages {
  final int _type;
  final String _to;
  final String _from;
  final String _content;
  final String _timestamp;
  final List<String?>? _images;
  bool _isDelivered = false;

  Messages(this._from, this._to, this._timestamp, this._content, this._images,
      this._type,
      [this._isDelivered = false]);

  void setDeliveryStatus(bool status) {
    _isDelivered = status;
  }

  bool getDeliveryStatus() => _isDelivered;

  int getMessageType() => _type;

  String getContent() => _content;

  List<String?>? getImages() => _images;

  bool hasOnlyText() => (_images == null || _images!.isEmpty);

  Map<String, dynamic> toJson() => {
        'from': _from,
        'to': _to,
        'timestamp': _timestamp,
        'content': _content,
        'images': _images,
        'type': _type,
      };

  Messages.fromJson(Map<String, dynamic> json)
      : _from = json['from'],
        _to = json['to'],
        _timestamp = json['timestamp'],
        _content = json['content'],
        _images = json['images'],
        _type = json['type'];
}
