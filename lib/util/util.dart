import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_creativity.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_data.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_model.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('Util');

String getStoreName() {
  if (kIsWeb) {
    return "Web Store";
  } else {
    if (Platform.isAndroid) {
      return "Play Store";
    } else if (Platform.isIOS) {
      return "App Store";
    } else if (Platform.isFuchsia) {
      return "Fuchsia Store";
    } else if (Platform.isLinux) {
      return "Linux Store";
    } else if (Platform.isMacOS) {
      return "App Store";
    } else if (Platform.isWindows) {
      return "Windows Store";
    }
    return "App Store";
  }
}

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

Future<String> getIpAddress() async {
  // final response = await http.get(Uri.parse('https://api.ipify.org'));
  // if (response.statusCode == 200) {
  //   return response.body;
  // } else {
  //   return not_available;
  // }
  return not_available;
}

String getDeviceType() {
  String platform;
  if (kIsWeb) {
    platform = 'web';
  } else {
    platform = Platform.operatingSystem;
  }
  return platform;
}

List<LLM> getMockLLMs() {
  log.d('getLLMs called');
  final llms = <LLM>[];

  final creativityLevels = <LLMCreativity>[];
  creativityLevels.add(LLMCreativity("1", "low", false));
  creativityLevels.add(LLMCreativity("2", "medium", false));
  creativityLevels.add(LLMCreativity("3", "high", false));
  creativityLevels.add(LLMCreativity("4", "higher", false));
  creativityLevels.add(LLMCreativity("5", "highest", false));

  final openAiModels = <LLMModel>[];
  openAiModels.add(LLMModel("1", "text_da_vinci", creativityLevels, false));
  openAiModels.add(LLMModel("2", "chat gpt", creativityLevels, false));
  openAiModels.add(LLMModel("3", "dall.3", creativityLevels, false));

  final claudeModels = <LLMModel>[];
  claudeModels.add(LLMModel("1", "Claude", creativityLevels, false));
  claudeModels.add(LLMModel("2", "Claude+", creativityLevels, false));

  final googleModels = <LLMModel>[];
  googleModels.add(LLMModel("1", "Bard", creativityLevels, false));

  llms.add(LLM("1", "OpenAI", openAiModels, "sk-4*************6T", false));
  llms.add(LLM("2", "Claude", claudeModels, "pk-4****6T", false));
  llms.add(LLM("3", "Google", googleModels, null, false));
  return llms;
}
