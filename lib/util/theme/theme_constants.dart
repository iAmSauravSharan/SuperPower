import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: colorCustom,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'NotoSerif',
  primaryColor: Colors.white,
  secondaryHeaderColor: Colors.white54,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
  dividerColor: const Color.fromARGB(31, 188, 188, 188),
  colorScheme: const ColorScheme.dark(
    primary: Colors.black,
    onBackground: Colors.black,
    onPrimary: Colors.white,
    shadow: Colors.white60,
    secondary: Colors.grey,
  ),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(179, 230, 229, 229),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.black54,
    textColor: Colors.white,
    visualDensity: VisualDensity.comfortable,
    dense: true,
    iconColor: Colors.white70,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 7,
      shadowColor: Color.alphaBlend(Color.fromARGB(255, 56, 56, 56), Colors.black),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        fontFamily: 'NotoSerif'
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 255, 255, 255),
        size: 24,
      )),
);

final lightTheme = ThemeData(
  primarySwatch: colorCustom,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'NotoSerif',
  primaryColor: const Color.fromARGB(255, 0, 0, 0),
  secondaryHeaderColor: const Color.fromARGB(255, 88, 88, 88),
  brightness: Brightness.light,
  backgroundColor: const Color.fromARGB(255, 231, 230, 230),
  scaffoldBackgroundColor: const Color.fromARGB(255, 219, 219, 219),
  dividerColor: const Color.fromARGB(255, 180, 180, 180),
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 255, 255, 255),
    onBackground: Color.fromARGB(255, 228, 228, 228),
    onPrimary: Color.fromARGB(255, 2, 2, 2),
    shadow: Color.fromARGB(153, 0, 0, 0),
    secondary: Colors.grey,
  ),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(179, 30, 30, 30),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color.fromARGB(137, 255, 255, 255),
    textColor: Color.fromARGB(255, 35, 35, 35),
    visualDensity: VisualDensity.comfortable,
    dense: true,
    iconColor: Color.fromARGB(179, 36, 36, 36),
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        fontFamily: 'NotoSerif',
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Color.fromARGB(255, 0, 0, 0),
        size: 24,
      )),
);

Map<int, Color> darkColor = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromARGB(178, 136, 14, 79),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

Map<int, Color> whiteColor = {
  50: const Color.fromARGB(255, 0, 0, 0),
  100: const Color.fromARGB(51, 33, 33, 33),
  200: const Color.fromARGB(74, 54, 54, 54),
  300: const Color.fromARGB(102, 75, 75, 75),
  400: const Color.fromARGB(126, 77, 77, 77),
  500: const Color.fromARGB(153, 92, 92, 92),
  600: const Color.fromARGB(177, 127, 127, 127),
  700: const Color.fromARGB(204, 185, 185, 185),
  800: const Color.fromARGB(228, 222, 222, 222),
  900: const Color.fromARGB(255, 255, 255, 255),
};

MaterialColor colorCustom = MaterialColor(0xFF880E4F, whiteColor);
