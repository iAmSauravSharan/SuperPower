import 'dart:async';

import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_repository.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/remote.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('Repository');

class Repository implements AuthenticationRepository {
  late final StreamController _controller;
  static Repository? instance;
  String _intention = Intention.qna.name;

  Repository._() {
    log.d("initializing repository..");
    _controller = StreamController();
  }

  final List<Messages> _messages = [];
  final Remote _remote = Remote();

  StreamController getController() => _controller;

  Future<void> getGreetings() async {
    _messages.addAll(await _remote.getGreetings());
    _controller.sink.add(_messages);
  }

  Future<void> sendQuery(String query) async {
    _remote.withThis(_intention);
    _messages.addAll(await _remote.sendQuery(Request(query)));
    _controller.sink.add(_messages);
  }

  Future<List<Option>> getOptions() async {
    _remote.withThis(_intention);
    return await _remote.getOptions();
  }

  void updateMessage(Messages message) {
    sendQuery(message.getContent());
    _messages.add(message);
    _controller.sink.add(_messages);
  }

  void setIntention(String name) {
    _intention = name;
  }

  factory Repository() => instance ??= Repository._();

  @override
  Future<Object> login(Login login) {
    return _remote.login(login);
  }

  @override
  Future<Object> resetPassword(ResetPassword resetPassword) {
    return _remote.resetPassword(resetPassword);
  }

  @override
  Future<Object> sendCode(VerifyCode verifyCode) {
      return _remote.sendCode(verifyCode);
  }

  @override
  Future<Object> signup(Signup signup) {
    return _remote.signup(signup);
  }

  @override
  Future<Object> verifyCode(VerifyCode verifyCode) {
    return _remote.verifyCode(verifyCode);
  }
}
