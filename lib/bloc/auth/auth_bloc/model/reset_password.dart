class ResetPassword {
  final String _username;
  final String _password;
  final String _ipAddress;
  final String _device;

  ResetPassword(this._username, this._password, this._ipAddress, this._device);

  String getUsername() => _username;

  Map<String, dynamic> toJson() => {
        'username': _username,
        'password': _password,
        'ipAddress': _ipAddress,
        'device': _device
      };

  ResetPassword.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _password = json['password'],
        _ipAddress = json['ipAddress'],
        _device = json['device'];
}
