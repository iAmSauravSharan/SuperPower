import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:superpower/screen/authentication_page/auth.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/routes.dart';
import 'package:superpower/util/theme/theme_bloc/theme_bloc.dart';
import 'package:superpower/util/theme/theme_constants.dart';

import 'firebase_options.dart';
import 'screen/home_page/home.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final log = Logging("Main");

Future main() async {
  await setup();
  return runApp(const LaunchApp());
}

class LaunchApp extends StatelessWidget {
  static const routeName = '/';
  const LaunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ThemeBloc(ThemeState(themeManager: AppState.getThemeManager())),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState state) {
          log.d("Launching App with theme ${state.themeManager.getTheme()}");
          return MaterialApp.router(
            title: "SuperPower⚡",
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: messengerKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeManager.getTheme(),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

class LaunchWidget extends StatelessWidget {
  const LaunchWidget({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: HomePage(),
      );

  Widget mainApp() => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return snackbar("Something went wrong", isError: true);
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        },
      );
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLogs();
  log.i("Launching App...................................");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppState.getThemeManager();
}

void setUpLogs() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}
