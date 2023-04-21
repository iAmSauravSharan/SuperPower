class Login {
  final String _username;
  final String _password;
  final String _ipAddress;
  final String _timestamp;
  final String _deviceType;

  Login(this._username, this._password, this._ipAddress, this._timestamp,
      this._deviceType);

  String getUsername() => _username;

  Map<String, dynamic> toJson() => {
        'email': _username.trim(),
        'password': _password,
        'timestamp': _timestamp,
        'ipAddress': _ipAddress,
        'device': _deviceType
      };

  Login.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _password = json['password'],
        _timestamp = json['timestamp'],
        _ipAddress = json['ipAddress'],
        _deviceType = json['device'];
}
