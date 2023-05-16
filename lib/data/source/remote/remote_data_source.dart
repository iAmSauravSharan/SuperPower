import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:superpower/bloc/app/app_bloc/model/app_preference.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';
import 'package:superpower/bloc/app/app_bloc/model/home_menu.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/login.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/reset_password.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/signup.dart';
import 'package:superpower/bloc/auth/auth_bloc/model/verify_code.dart';
import 'package:superpower/bloc/chat/chat_bloc/model/chat.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/user_llm_preference.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/payment.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/subscription.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/data/source/remote/interceptors/append_headers_interceptor.dart';
import 'package:superpower/data/source/remote/interceptors/logging_interceptor.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';
import 'package:superpower/util/util.dart';

class RemoteDataSource {
  final log = Logging("Remote");
  String _intention = Intention.qna.name;

  static bool idToken = false;
  static bool accessToken = false;

  late final InterceptedHttp http;

  RemoteDataSource() {
    http = InterceptedHttp.build(
        interceptors: [AppendHeadersInterceptor(), LoggingInterceptor()]);
  }

  Future<List<Messages>> getGreetings() async {
    List<Messages> messages = [];
    final response = await http.get(Uri.parse('${baseUrl}greet'));
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

  Future<List<Messages>> sendQuery(
      Request request, Map<String, String> queryParam) async {
    List<Messages> messages = [];
    const String url = '$aiBaseUrl/ask';
    final response = await http.post(
      Uri.parse(url),
      params: queryParam,
      body: request.toJson().toString(),
    );
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
    final response = await http.get(Uri.parse(url));
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

  RemoteDataSource withThis(String intention) {
    _intention = intention;
    return this;
  }

  Future<Object> login(Login login) async {
    log.d('login request -> ${login.toJson()}');
    final url = Uri.parse('$authBaseUrl/login');
    log.d('login argument is -> ${login.toJson().toString()}');
    final response = await http.post(
      url,
      body: login.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> resetPassword(ResetPassword resetPassword) async {
    final url = Uri.parse('$authBaseUrl/forgotpassword');
    log.d('resetPassword argument is -> ${resetPassword.toJson().toString()}');
    final response = await http.post(
      url,
      body: resetPassword.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> sendCode(VerifyCode verifyCode) async {
    final url = Uri.parse('$authBaseUrl/sendcode');
    log.d('sendCode argument is -> ${verifyCode.toJson().toString()}');
    final response = await http.post(
      url,
      body: verifyCode.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> signup(Signup signup) async {
    final url = Uri.parse('$authBaseUrl/users');
    log.d('sign up argument is -> ${signup.toJson().toString()}');
    final response = await http.post(
      url,
      body: signup.toJson().toString(),
    );
    return decoded(response);
  }

  Future<Object> confirmUser(VerifyCode verifyCode) async {
    final url = Uri.parse('$authBaseUrl/confirm');
    log.d('confirmUser argument is -> ${verifyCode.toJson().toString()}');
    final response = await http.post(
      url,
      body: verifyCode.toJson().toString(),
    );
    return decoded(response);
  }

  Object decoded(response) {
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
    accessToken = true;
    const url = "$authBaseUrl/users/me";
    log.d("url is -> $url");
    final rawResponse = await http.get(Uri.parse(url));
    final response = decoded(rawResponse) as Map<String, dynamic>;
    final userDetails = response['user'] as Map<String, dynamic>;
    final user =
        User(userDetails['username'] as String, userDetails['email'] as String);
    accessToken = false;
    return user;
  }

  //TODO: call logout API
  Future<Object> logout() {
    return Future.delayed(const Duration(milliseconds: 300), () => {});
  }

  //TODO: get user preference from the API
  Future<UserPreference> getUserPreference() {
    return Future.delayed(
        const Duration(milliseconds: 300), () => UserPreference("Light", "10"));
  }

  //TODO: get app preference from the API
  Future<AppPreference> getAppPreference() {
    List<HomeMenu> menuList = <HomeMenu>[];
    menuList.add(HomeMenu("QnA", "", ""));
    menuList.add(HomeMenu("Code", "", ""));
    menuList.add(HomeMenu("Translator", "", ""));
    menuList.add(HomeMenu("Story", "", ""));
    menuList.add(HomeMenu("Chat", "", ""));
    menuList.add(HomeMenu("Image", "", ""));
    return Future.delayed(
        const Duration(milliseconds: 300), () => AppPreference(menuList));
  }

  //TODO: get user llm preference from the API
  Future<UserLLMPreference> getUserLLMPreference() {
    Map<String, String> accessKeys = <String, String>{};
    accessKeys["1"] = "sk-4*************Pr7";
    accessKeys["3"] = "gp-5*************Ph9";
    return Future.delayed(const Duration(milliseconds: 300),
        () => UserLLMPreference("1", "2", "1", accessKeys, "1"));
  }

  //TODO: get llms from the API
  Future<List<LLM>> getLLMs() {
    return Future.delayed(
        const Duration(milliseconds: 300), () => getMockLLMs());
  }

  //TODO: update user preference llm to server
  Future<Object> updateUserLLMPreference(UserLLMPreference preference) {
    return Future.delayed(
        const Duration(milliseconds: 300),
        () =>
            {log.d('update user llm pref called with ${preference.toJson()}')});
  }

  Future<Object> updateUserPreference(UserPreference userPreference) {
    return Future.value(SUCCESS);
  }

  Future<Chat> getChatPreference() {
    return Future.delayed(
        const Duration(milliseconds: 300), () => Chat("", ""));
  }

  Future<void> submitFeedback(double rating, String feedback) {
    return Future.delayed(const Duration(milliseconds: 300), () => {});
  }

  Future<Payment> getPaymentDetails(String appId) {
    const monthlySubscriptionBenefits = [
      "Unlimited Chat History",
      "Token limit upto 32k",
      "Access to GPT4 and Bard LLM",
    ];
    const annualSubscriptionBenefits = [
      "Everything included in monthly",
      "Token limit upto 64k",
      "Unlimited Chat profiles",
    ];
    const subscriptions = [
      Subscription(1, "Monthly", "\$34", "In Annual, you get 2 months free",
          monthlySubscriptionBenefits),
      Subscription(1, "Annual", "\$29/month", "", annualSubscriptionBenefits),
    ];
    const paymentDetails = Payment("Unlock all features",
        "get daily updates, crafted for you", subscriptions);
    return Future.delayed(
        const Duration(milliseconds: 300), () => paymentDetails);
  }

  Future<List<FAQ>> getFAQs() {
    final faqs = <FAQ>[];
    faqs.add(const FAQ("How can I use this app?",
        "You can use this app to ask your queries at different level. You could ask AI to solve your maths problem, your day to day coding problems, as well as you could ask for health related tips."));
    faqs.add(const FAQ("What are different mode of Payment is supported?",
        "We support in app payments from google play store, apple app store as well as custom payments mode with credit cards, debit cards. internet banking and UPIs"));
    return Future.delayed(const Duration(microseconds: 300), () => faqs);
  }
}
