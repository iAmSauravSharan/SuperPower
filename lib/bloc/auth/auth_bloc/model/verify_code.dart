class VerifyCode {
  final String _username;
  final String _code;
  final String _email;
  final String _phone;
  final String _ipAddress;
  final String _device;

  VerifyCode(this._username, this._code, this._email, this._phone,
      this._ipAddress, this._device);

  String getUsername() => _username;

  Map<String, dynamic> toJson() => {
        'username': _username,
        'code': _code,
        'email': _email,
        'phone': _phone,
        'ipAddress': _ipAddress,
        'device': _device
      };

  VerifyCode.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _code = json['code'],
        _email = json['email'],
        _ipAddress = json['ipAddress'],
        _device = json['device'],
        _phone = json['phone'];
}
