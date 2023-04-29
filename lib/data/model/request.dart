class Request {
  final String _query;

  Request(this._query);

  String getQuery() => _query;

  Map<String, dynamic> toJson() => {'query': _query};

  Request.fromJson(Map<String, dynamic> json) : _query = json['query'];
}
