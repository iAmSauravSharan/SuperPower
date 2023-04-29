import 'dart:async';

import 'package:flutter/material.dart';
import 'package:superpower/app.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/logging.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final log = Logging("Main");

Future main() async {
  await setup();
  return runApp(const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!AppState.isProd) {
    Logging.enableLogging();
  }
  AppState.initialize;
  log.i("Launching App...................................");
}
