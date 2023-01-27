class Option {
  final String _option;

  Option(this._option);

  String getOption() => _option;

  Map<String, dynamic> toJson() => {'option': _option};

  Option.fromJson(Map<String, dynamic> json) : _option = json['option'];
}

class Options {
  List<Option> _options;

  Options(this._options);

  List<Option> getOptions() => _options;

  factory Options.fromJson(List<dynamic> parsedJson) {
    List<Option> options = [];
    options = parsedJson.map((i) => Option.fromJson(i)).toList();
    return Options(options);
  }
}
