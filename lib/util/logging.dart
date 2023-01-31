import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

class Logging {
  late String name;
  late Logger log;

  Logging(String className) {
    name = className;
    log = Logger(name);
  }

  void d(String message) {
    log.fine('$name -> $message');
  }

  void i(String message) {
    log.info('$name -> $message');
  }

  void e(String message) {
    log.shout('$name -> $message');
  }

  void w(String message) {
    log.warning('$name -> $message');
  }

  static void enableLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}
