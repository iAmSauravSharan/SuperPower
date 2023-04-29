import 'package:equatable/equatable.dart';

class FAQ extends Equatable {
  final String _title;
  final String _content;

  const FAQ(this._title, this._content);

  String getTitle() => _title;
  String getContent() => _content;

  Map<String, dynamic> toJson() => {'title': _title, 'content': _content};

  FAQ.fromJson(Map<String, dynamic> json)
      : _title = json['title'],
        _content = json['content'];

  @override
  String toString() => toJson().toString();

  @override
  List<Object?> get props => [_title];
}
