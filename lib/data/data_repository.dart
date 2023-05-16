import 'dart:async';
import 'dart:convert';

import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';
import 'package:superpower/bloc/app/app_repository.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/auth/auth_repository.dart';
import 'package:superpower/bloc/chat/chat_bloc/model/chat.dart';
import 'package:superpower/bloc/chat/chat_repository.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/user_llm_preference.dart';
import 'package:superpower/bloc/llm/llm_repository.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/payment.dart';
import 'package:superpower/bloc/payment/payment_repository.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/bloc/user/user_repository.dart';
import 'package:superpower/data/model/cache_repository.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/data/source/cache/cache_data_source.dart';
import 'package:superpower/data/source/remote/remote_data_source.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';

final log = Logging('Repository');

class DataRepository
    implements
        AuthenticationRepository,
        UserRepository,
        CacheRepository,
        LLMRepository,
        ChatRepository,
        AppRepository,
        PaymentRepository {
  late final StreamController _controller;
  static DataRepository? instance;
  String _intention = Intention.qna.name;

  final List<Messages> _messages = [];
  late final RemoteDataSource _remote;
  late final CacheDataSource _cache;

  DataRepository._() {
    log.d("initializing repository..");
    _controller = StreamController();
    _remote = RemoteDataSource();
    _cache = CacheDataSource();
  }

  factory DataRepository() => instance ??= DataRepository._();

  StreamController getController() => _controller;

  @override
  Future<String> getToken(TokenType type) {
    return _cache.getToken(type);
  }

  @override
  Future<bool> isInitialAppLaunch() {
    return _cache.isInitialAppLaunch();
  }

  @override
  void setAppLaunchStatus(bool status) {
    _cache.setAppLaunchStatus(status);
  }

  @override
  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await _cache.isLoggedIn();
    return Future.value(isLoggedIn);
  }

  @override
  void setLoggedInStatus(bool isLoggedIn) {
    return _cache.setLoggedInStatus(isLoggedIn);
  }

  @override
  void saveToken(TokenType tokenType, String token) {
    log.d('saving ${tokenType.name} with value $token');
    _cache.saveToken(tokenType, token);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  Future<void> getGreetings() async {
    _messages.addAll(await _remote.getGreetings());
    _controller.sink.add(_messages);
  }

  Future<void> sendQuery(String query) async {
    _remote.withThis(_intention);
    final queryParam = <String, String>{};
    // final UserLLMPreference userLLMPreference =
    //     await _cache.getUserLLMPreference() ?? UserLLMPreference();
    // final List<LLM> llms = await getLLMs();
    String vendorName = "open_ai",
        modelName = "text-davinci-003",
        intention = "lets-talk",
        creativityLevel = "0.1";
    // for (var llm in llms) {
    //   if (userLLMPreference.getVendor() == llm.getId()) {
    //     vendorName = llm.getVendor();
    //     for (var model in llm.getModel()) {
    //       if (userLLMPreference.getModel() == model.getId()) {
    //         modelName = model.getName();
    //         for (var creativity in model.getCreativityLevels()) {
    //           if (userLLMPreference.getCreativityLevel() ==
    //               creativity.getId()) {
    //             creativityLevel = creativity.getName();
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    queryParam['vendor'] = vendorName;
    queryParam['model'] = modelName;
    queryParam['intention'] = intention;
    queryParam['response_creativity'] = creativityLevel;
    _messages.addAll(await _remote.sendQuery(Request(query), queryParam));
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
  Future<Object> refreshToken(String token) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<User> getUser() {
    return _remote.getUser();
  }

  @override
  Future<UserLLMPreference> getUserLLMPreference() async {
    UserLLMPreference? userLLMPreference = await _cache.getUserLLMPreference();
    if (userLLMPreference == null) {
      userLLMPreference = await _remote.getUserLLMPreference();
      _cache.updateUserLLMPreference(userLLMPreference);
    }
    return Future.value(userLLMPreference);
  }

  @override
  Future<Object> updateAccessKey(Map<String, String> accessKey) async {
    final savedKeys = await _cache.getLLMAccessKeys();
    if (savedKeys != null) {
      accessKey.addAll(Map<String, String>.from(json.decode(savedKeys)));
    }
    _cache.setLLMAccessKeys(accessKey);
    return Future.value(SUCCESS);
  }

  @override
  Future<Object> updateCreativityLevel(String creativityLevel) {
    _cache.setLLMCreativityLevel(creativityLevel);
    return Future.value(SUCCESS);
  }

  @override
  Future<Object> updateModel(String model) {
    _cache.setLLMModel(model);
    return Future.value(SUCCESS);
  }

  @override
  Future<Object> updateVendor(String vendor) {
    _cache.setLLMVendor(vendor);
    return Future.value(SUCCESS);
  }

  @override
  Future<List<LLM>> getLLMs() async {
    List<LLM>? llms = await _cache.getLLMs();
    if (llms == null || llms.isEmpty) {
      llms = await _remote.getLLMs();
    }
    _cache.saveLLMs(llms);
    return llms;
  }

  @override
  Future<Object> updateUserLLMPreference() async {
    log.d('in update user llm method 1');
    Map<String, String> accessKeys = <String, String>{};
    String vendorId = await _cache.getLLMVendor() ?? "1";
    String modelId = await _cache.getLLMModel() ?? "1";
    String creativityId = await _cache.getLLMCreativityLevel() ?? "1";
    final savedAccessKeys = await _cache.getLLMAccessKeys();
    if (savedAccessKeys != null) {
      accessKeys = Map<String, String>.from(json.decode(savedAccessKeys));
    }
    UserLLMPreference llmPreference =
        UserLLMPreference("1", vendorId, modelId, accessKeys, creativityId);
    log.d('in update user LLM preference ${llmPreference.toJson().toString()}');
    _cache.updateUserLLMPreference(llmPreference);
    return _remote.updateUserLLMPreference(llmPreference);
  }

  @override
  Future<UserPreference> getUserPreference() async {
    UserPreference? userPreference = await _cache.getUserPreference();
    if (userPreference == null) {
      userPreference = await _remote.getUserPreference();
      _cache.updateUserPreference(userPreference);
    }
    return userPreference;
  }

  @override
  Future<AppPreference> getAppPreference() async {
    AppPreference? appPreference = await _cache.getAppPreference();
    if (appPreference == null) {
      appPreference = await _remote.getAppPreference();
      _cache.updateAppPreference(appPreference);
    }
    final json = jsonDecode(appPreference as String) as Map<String, dynamic>;
    return AppPreference.fromJson(json);
  }

  @override
  Future<Chat> getChat() {
    // TODO: implement getChat
    throw UnimplementedError();
  }

  @override
  Future<Chat> getChatPreference() async {
    final preference = await _cache.getChatPreference();
    return preference ?? await _remote.getChatPreference();
  }

  @override
  Future<Object> updateUserPreference(UserPreference userPreference) {
    _cache.updateUserPreference(userPreference);
    return _remote.updateUserPreference(userPreference);
  }

  @override
  void saveTheme(String themeType, String theme) {
    _cache.saveTheme(themeType, theme);
  }

  Future<void> loadInitialData() async {
    await _remote.getAppPreference();
    await _remote.getUserPreference();
    await _remote.getUserLLMPreference();
  }

  @override
  Future<void> submitFeedback(double rating, String feedback) {
    return _remote.submitFeedback(rating, feedback);
  }

  @override
  Future<List<FAQ>> getFAQs() async {
    var faqs = await _cache.getFAQs();
    if (faqs == null) {
      faqs = await _remote.getFAQs();
      _cache.saveFAQs(faqs);
    }
    return Future.value(faqs);
  }

  @override
  Future<Payment> getPaymentDetails() {
    String appId = "anuRandomTHing";
    return _remote.getPaymentDetails(appId);
  }
}
