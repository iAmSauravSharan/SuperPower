import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/data/preference_manager.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

class Remote {
  final log = Logging("Remote");
  String _intention = Intention.qna.name;

  Future<Map<String, String>> getHeaders() async => {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization': await PreferenceManager.readData(bearerToken),
        'Accept': '*/*'
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
      log.d("in getGreetings - error in response with status code -> ${response.statusCode}");
    }
    return messages;
  }

  Future<List<Messages>> sendQuery(Request request) async {
    List<Messages> messages = [];
    final String url = '${baseUrl}$_intention?prompt=${request.getQuery()}';
    log.d("in sendQuery() - url is -> $url");
    final response = await http.get(Uri.parse(url),
        headers: await getHeaders());
    if (response.statusCode == 200) {
      log.d("in sendQuery - response is -> ${response.body}");
      messages.add(Messages.fromJson(jsonDecode(response.body)));
      log.d("in sendQuery - messages -> ${messages.toString()}");
    } else {
      log.d("in sendQuery - response failed with status code -> ${response.statusCode}");
    }
    return messages;
  }

  Future<List<Option>> getOptions() async {
    List<Option> optionList = [];
    //TODO: move intention to proper param
    final url = "${baseUrl}options?intention=$_intention";
    log.d("in getOptions() - url is -> $url");
    final response = await http.get(Uri.parse(url), headers: await getHeaders());
    log.d("in getOptions() - response is -> ${response.body}");
    if (response.statusCode == 200) {
      Options options = Options.fromJson(jsonDecode(response.body));
      optionList = options.getOptions();
      log.d("in getOptions() -  optionList -> $optionList");
    } else {
      log.d("in getOptions -> request failed with response code ${response.statusCode}");
    }
    return optionList;
  }

  Remote withThis(String intention) {
    _intention = intention;
    return this;
  }
}
