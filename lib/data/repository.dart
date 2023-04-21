import 'dart:async';

import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_repository.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_data.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_repository.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/bloc/user/user_repository.dart';
import 'package:superpower/data/model/cache_repository.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/preference_manager.dart';
import 'package:superpower/data/remote.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('Repository');

class Repository
    implements
        AuthenticationRepository,
        UserRepository,
        CacheRepository,
        LLMRepository {
  late final StreamController _controller;
  static Repository? instance;
  String _intention = Intention.qna.name;

  final List<Messages> _messages = [];
  final Remote _remote = Remote();

  Repository._() {
    log.d("initializing repository..");
    _controller = StreamController();
  }

  factory Repository() => instance ??= Repository._();
  StreamController getController() => _controller;

  @override
  Future<String> getToken(TokenType type) {
    return PreferenceManager.readData(type.name) as Future<String>;
  }

  @override
  Future<bool> initialAppLaunch() {
    return PreferenceManager.readData(PrefConstant.initialLaunch)
        as Future<bool>;
  }

  @override
  void setAppLaunchStatus(bool status) {
    PreferenceManager.saveData(PrefConstant.initialLaunch, status);
  }

  @override
  Future<bool> isLogin() {
    return PreferenceManager.readData(PrefConstant.loggedInStatus)
        as Future<bool>;
  }

  @override
  void setLoggedinStatus(bool isLoggedIn) {
    return PreferenceManager.saveData(PrefConstant.loggedInStatus, isLoggedIn);
  }

  @override
  void saveToken(TokenType tokenType, String token) {
    log.d('saving ${tokenType.name} with value $token');
    PreferenceManager.saveData(tokenType.name, token);
  }

  @override
  Future<void> clear() async {
    PreferenceManager.deleteData(TokenType.accessToken.name);
    PreferenceManager.deleteData(TokenType.idToken.name);
    PreferenceManager.deleteData(TokenType.refreshToken.name);
    PreferenceManager.saveData(PrefConstant.loggedInStatus, false);
  }

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

  @override
  Future<Object> login(Login login) {
    // return Future.delayed(Duration(milliseconds: 300), () => {});
    return _remote.login(login);
  }

  @override
  Future<Object> resetPassword(ResetPassword resetPassword) {
    // return Future.delayed(Duration(milliseconds: 300), () => {});
    return _remote.resetPassword(resetPassword);
  }

  @override
  Future<Object> sendCode(VerifyCode verifyCode) {
    // return Future.delayed(Duration(milliseconds: 300), () => {});
    return _remote.sendCode(verifyCode);
  }

  @override
  Future<Object> signup(Signup signup) {
    // return Future.delayed(Duration(milliseconds: 300), () => {});
    return _remote.signup(signup);
  }

  @override
  Future<Object> confirmUser(VerifyCode verifyCode) {
    // return Future.delayed(Duration(milliseconds: 300), () => {});
    return _remote.confirmUser(verifyCode);
  }

  @override
  Future<Object> logout() {
    return _remote.logout().whenComplete(() => clear());
  }

  @override
  Future<User> getUser() {
    return _remote.getUser();
  }

  @override
  Future<String> getAccessKey() {
    return _remote.getAccessKey();
  }

  @override
  Future<LLM> getUserLLMPreference() {
    return _remote.getUserLLMPreference();
  }

  @override
  Future<Object> updateAccessKey(String accessKey) {
    return _remote.updateAccessKey(accessKey);
  }

  @override
  Future<Object> updateCretivityLevel(String creativityLevel) {
    return _remote.updateCretivityLevel(creativityLevel);
  }

  @override
  Future<Object> updateModel(String model) {
    return _remote.updateModel(model);
  }

  @override
  Future<Object> updateVendor(String vendor) {
    return _remote.updateVendor(vendor);
  }

  @override
  Future<List<LLM>> getLLMs() {
    return _remote.getLLMs();
  }
}
