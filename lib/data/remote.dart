import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/data/preference_manager.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

class Remote {
  final log = Logging("Remote");
  String _intention = Intention.qna.name;

  Future<Map<String, String>> getHeaders({
    bool idToken = false,
    bool accessToken = false,
    bool refreshToken = false,
  }) async =>
      {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        if (idToken)
          TokenType.Authorization.name:
              await PreferenceManager.readData(TokenType.idToken.name),
        if (accessToken)
          TokenType.Authorization.name:
              await PreferenceManager.readData(TokenType.accessToken.name),
        if (refreshToken)
          TokenType.Authorization.name:
              await PreferenceManager.readData(TokenType.refreshToken.name),
      };

  Future<List<Messages>> getGreetings() async {
    List<Messages> messages = [];
    final response = await http.get(Uri.parse('${baseUrl}greet'),
        headers: await getHeaders());
    if (response.statusCode == 200) {
      log.d("in getGreetings - response body -> ${response.body}");
      messages.add(Messages.fromJson(jsonDecode(response.body)));
      log.d("in getGreetings - messages -> ${messages.toString()}");
    } else {
      log.d(
          "in getGreetings - error in response with status code -> ${response.statusCode}");
    }
    return messages;
  }

  Future<List<Messages>> sendQuery(Request request) async {
    List<Messages> messages = [];
    final String url = '$baseUrl$_intention?prompt=${request.getQuery()}';
    log.d("in sendQuery() - url is -> $url");
    final response =
        await http.get(Uri.parse(url), headers: await getHeaders());
    if (response.statusCode == 200) {
      log.d("in sendQuery - response is -> ${response.body}");
      messages.add(Messages.fromJson(jsonDecode(response.body)));
      log.d("in sendQuery - messages -> ${messages.toString()}");
    } else {
      log.d(
          "in sendQuery - response failed with status code -> ${response.statusCode}");
    }
    return messages;
  }

  Future<List<Option>> getOptions() async {
    List<Option> optionList = [];
    //TODO: move intention to proper param
    final url = "${baseUrl}options?intention=$_intention";
    log.d("in getOptions() - url is -> $url");
    final response =
        await http.get(Uri.parse(url), headers: await getHeaders());
    log.d("in getOptions() - response is -> ${response.body}");
    if (response.statusCode == 200) {
      Options options = Options.fromJson(jsonDecode(response.body));
      optionList = options.getOptions();
      log.d("in getOptions() -  optionList -> $optionList");
    } else {
      log.d(
          "in getOptions -> request failed with response code ${response.statusCode}");
    }
    return optionList;
  }

  Remote withThis(String intention) {
    _intention = intention;
    return this;
  }

  Future<Object> login(Login login) async {
    log.d('login request -> ${login.toJson()}');
    final url = Uri.parse('$authBaseUrl/login');
    log.d('login argument is -> ${login.toJson().toString()}');
    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: login.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> resetPassword(ResetPassword resetPassword) async {
    final url = Uri.parse('$authBaseUrl/forgotpassword');
    log.d('resetPassword argument is -> ${resetPassword.toJson().toString()}');
    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: resetPassword.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> sendCode(VerifyCode verifyCode) async {
    final url = Uri.parse('$authBaseUrl/sendcode');
    log.d('sendCode argument is -> ${verifyCode.toJson().toString()}');
    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: verifyCode.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> signup(Signup signup) async {
    final url = Uri.parse('$authBaseUrl/users');
    log.d('sign up argument is -> ${signup.toJson().toString()}');
    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: signup.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> confirmUser(VerifyCode verifyCode) async {
    final url = Uri.parse('$authBaseUrl/confirm');
    log.d('confirmUser argument is -> ${verifyCode.toJson().toString()}');
    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: verifyCode.toJson().toString(),
    );
    return decoded(response);
  }

  Object decoded(http.Response response) {
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    log.d('response status code ->  ${response.statusCode}');
    log.d('\nresponse body came as -> ${response.body.toString()}');
    log.d(decodedResponse.toString());
    String message = (decodedResponse.containsKey('message') &&
            decodedResponse['message'] != null)
        ? decodedResponse['message']
        : response.statusCode != 200
            ? 'Unknown error occured'
            : '';

    if (message.isNotEmpty) {
      snackbar(
        message,
        isError: (response.statusCode != 200),
        isInfo: (response.statusCode == 200),
      );
    }
    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      log.e(message);
      throw Exception(message);
    }
  }

  Future<User> getUser() async {
    final headers = await getHeaders(accessToken: true);
    const url = "$authBaseUrl/users/me";
    log.d("header is -> $headers");
    log.d("url is -> $url");
    final rawResponse = await http.get(Uri.parse(url), headers: headers);
    final response = decoded(rawResponse) as Map<String, dynamic>;
    final userDetails = response['user'] as Map<String, dynamic>;
    final user =
        User(userDetails['username'] as String, userDetails['email'] as String);
    return user;
  }

  Future<Object> logout() {
    //TODO: call logout API
    return Future.delayed(const Duration(milliseconds: 300), () => {});
  }

  Future<String> getAccessKey() {
    // TODO: implement getAccessKey
    throw UnimplementedError();
  }

  Future<LLM> getUserLLMPreference() {
    // TODO: implement getUserLLMPreference
    throw UnimplementedError();
  }

  Future<List<LLM>> getLLMs() {
    // TODO: implement getVendors
    throw UnimplementedError();
  }

  Future<Object> updateAccessKey(String accessKey) {
    // TODO: implement updateAccessKey
    throw UnimplementedError();
  }

  Future<Object> updateCretivityLevel(String creativityLevel) {
    // TODO: implement updateCretivityLevel
    throw UnimplementedError();
  }

  Future<Object> updateModel(String model) {
    // TODO: implement updateModel
    throw UnimplementedError();
  }

  Future<Object> updateVendor(String vendor) {
    return Future.delayed(const Duration(milliseconds: 300),
        () => {log.d('update vendor called with $vendor')});
  }
}
