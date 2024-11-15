

import 'package:logger/logger.dart';
import '../di/dependency_injector.dart';

// Logger debugLogger = Logger(level: Level.debug);
DebugLog logger = DebugLog();


class DebugLog {

  void log(String context, String message) {
   sl<Logger>().d("${DateTime.now()}: $context: $message",);
  }

}