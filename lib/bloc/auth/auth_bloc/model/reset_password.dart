class ResetPassword {
  final String _username;
  final String _password;
  final String _code;
  final String _ipAddress;
  final String _device;

  ResetPassword(this._username, this._password, this._code, this._ipAddress,
      this._device);

  String getUsername() => _username;

  Map<String, dynamic> toJson() => {
        'email': _username.trim(),
        'password': _password,
        'code': _code,
        'ipAddress': _ipAddress,
        'device': _device
      };

  ResetPassword.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _password = json['password'],
        _code = json['code'],
        _ipAddress = json['ipAddress'],
        _device = json['device'];
}
