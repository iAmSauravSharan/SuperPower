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
}
