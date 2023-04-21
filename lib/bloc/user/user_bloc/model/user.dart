class User {
  final String _username;
  final String _email;

  User(this._username, this._email);

  String getUsername() => _username;
  String getEmail() => _email;

  Map<String, dynamic> toJson() =>
      {'username': _username.trim(), 'email': _email.trim()};

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _email = json['email'];
}
