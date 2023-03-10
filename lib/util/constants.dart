// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const String TERMS_AND_CONDITIONS_PREFIX =
    'By using this app, you must agree with our\n';
const String TERMS_AND_CONDITIONS = 'Terms of usage';
const String PRIVACY_POLICY = 'Privacy Policy';
const String AND = ' and ';

const String systemTheme = "System";
const String lightTheme = "Light";
const String darkTheme = "Dark";
const themes = <String>[systemTheme, lightTheme, darkTheme];

class PrefConstant {
  static const String themeMode = 'themeModePref';
}

class Constants {
  static const int system = 1;
  static const int user = 2;
  static const int systemImage = 3;
  static const int userImage = 4;
  static const int broadcast = 5;

  static const String baseUrl = "http://localhost:8084/";
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
  static const Color tilesColor = Color.fromARGB(255, 232, 243, 249);
  static const Color iconColor = Colors.black;
  static const bool isTilesDensed = true;
  static const TextStyle tilesTitleStyle =
      TextStyle(fontSize: 17);
}

enum Intention { qna, image, chat, translator, story, code }

enum Preference { isAuthenticated }

enum Path { terms_of_usage, privacy_policy }
