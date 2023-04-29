

import 'package:superpower/util/constants.dart';

class Signup {
  final String _username;
  final String _email;
  final String _password;
  final String _ipAddress;
  final String _timestamp;
  final String _deviceType;

  Signup(this._username, this._email, this._password, this._ipAddress,
      this._timestamp, this._deviceType);

  String getUsername() => _username;

  Map<String, dynamic> toJson() => {
        'email': _email.trim(),
        'username': _username.trim(),
        'password': _password,
        'timestamp': _timestamp,
        'ipAddress': _ipAddress,
        'device': _deviceType
      };

  Signup.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _email = json['email'],
        _password = json['password'],
        _timestamp = json['timestamp'],
        _ipAddress = json['ipAddress'],
        _deviceType = json['device'];
}
