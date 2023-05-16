import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_creativity.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_model.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:url_launcher/url_launcher.dart';

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

void sendEmail([String subject = "", String body = ""]) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (subject.isEmpty) {
    subject = "contact -";
  }
  if (body.isEmpty) {
    String appName = packageInfo.appName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    body = """
\n\n\n\n- Device info
App name: $appName
App version: $version
Build number: $buildNumber""";
  }
  final Uri uri = Uri(
    scheme: 'mailto',
    path: developerMailId,
    query: 'subject=$subject&body=$body',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    snackbar('Unable to launch email service', isError: true);
  }
}

void launchWebpageWith(String url,
    [LaunchMode mode = LaunchMode.externalApplication]) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    launchUrl(uri, mode: mode);
  } else {
    snackbar('Could not launch $url', isError: true);
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

DeviceType getDeviceType() {
  if (kIsWeb) {
    return DeviceType.web;
  } else if (Platform.operatingSystem == 'android') {
    return DeviceType.android;
  } else if (Platform.operatingSystem == 'ios') {
    return DeviceType.ios;
  } else if (Platform.operatingSystem == 'windows') {
    return DeviceType.windows;
  } else if (Platform.operatingSystem == 'macos') {
    return DeviceType.macos;
  } else if (Platform.operatingSystem == 'linux') {
    return DeviceType.linux;
  } else if (Platform.operatingSystem == 'fuchsia') {
    return DeviceType.fuchsia;
  }
  return DeviceType.web;
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
  openAiModels.add(LLMModel("1", "text-davinci-003", creativityLevels, false));
  openAiModels.add(LLMModel("2", "gpt-3.5-turbo", creativityLevels, false));
  openAiModels.add(LLMModel("3", "gpt-4", creativityLevels, false));
  openAiModels.add(LLMModel("4", "dall.3", creativityLevels, false));

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
