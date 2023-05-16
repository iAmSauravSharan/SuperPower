// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const String baseUrl = "http://localhost:8184/";
const String aiBaseUrl = "https://2uxj9741p5.execute-api.ap-south-1.amazonaws.com/Prod";
const String authBaseUrl =
    "https://44kvrs9fch.execute-api.ap-south-1.amazonaws.com/Prod";

const String none = '';
const String not_available = 'na';

const String bearerToken = "Bearer Token";
const String idToken = "idToken";

const String developerMailId = "contact@wakta.com";

const String googlePlayUrl =
    "https://play.google.com/store/apps/details?id=com.netflix.mediaclient&hl=en_IN&gl=US&pli=1";
const String appStoreUrl = "https://apps.apple.com/in/app/netflix/id363590051";
const String microsoftStoreUrl =
    "https://www.microsoft.com/store/productId/9WZDNCRFJ3TJ";
const String linuxStoreUrl = "https://www.netflix.com/in/";
const String webStoreUrl = "https://www.netflix.com/in/";

class PrefConstant {
  static const String themeMode = 'themeModePref';
  static const String initialLaunch = 'initialLaunchPref';
  static const String loggedInStatus = 'loggedInStatusPref';
  static const String userLLMPreference = 'userLLMPreference';
  static const String userPreference = 'userPreference';
  static const String appPreference = 'appPreference';
  static const String appFAQs = 'appFAQs';
  static const String chatPreference = 'chatPreference';
  static const String llmOptions = 'llmOptions';
  static const String userLLMVendor = 'userLLMVendor';
  static const String userLLMModel = 'userLLMModel';
  static const String userLLMCreativityLevel = 'userLLMCreativityLevel';
  static const String userLLMAccessKeys = 'userLLMAccessKeys';
}

class PostType {
  static const int image = 1;
  static const int video = 2;
  static const int text = 3;
}

class MessageType {
  static const int system = 1;
  static const int user = 2;
  static const int systemImage = 3;
  static const int userImage = 4;
  static const int broadcast = 5;
}

class ColorFor {
  static const Color qNAOption = Color.fromARGB(230, 16, 135, 209);
  static const Color codeOption = Color.fromARGB(255, 25, 73, 230);
  static const Color translatorOption = Color.fromARGB(255, 230, 25, 59);
  static const Color chatOption = Color.fromARGB(230, 71, 16, 209);
  static const Color imageOption = Color.fromARGB(255, 84, 152, 11);
  static const Color storyOption = Color.fromARGB(255, 230, 141, 25);
}

class IconFor {
  static const IconData qNAOption = Icons.question_mark_rounded;
  static const IconData codeOption = Icons.code_rounded;
  static const IconData translatorOption = Icons.language_rounded;
  static const IconData chatOption = Icons.question_answer_rounded;
  static const IconData imageOption = Icons.image_rounded;
  static const IconData storyOption = Icons.import_contacts_rounded;
}

class PathFor {
  static const String qNAOption = "QnA";
  static const String codeOption = "Code";
  static const String translatorOption = "Translator";
  static const String chatOption = "Chat";
  static const String imageOption = "Image";
  static const String storyOption = "Story";
}

class Profile {
  static const Color tilesColor = Color.fromARGB(255, 245, 249, 252);
  static const Color iconColor = Colors.black;
  static const bool isTilesDensed = true;
  static const TextStyle tilesTitleStyle = TextStyle(fontSize: 17);
}

enum Intention { qna, image, chat, translator, story, code }

enum Preference { isAuthenticated }

enum Path { terms_of_usage, privacy_policy }

enum VerifyingCodeFor { user_signup, reset_password }

enum TokenType { Authorization, idToken, accessToken, refreshToken }

enum DeviceType { android, fuchsia, ios, linux, macos, windows, web }
