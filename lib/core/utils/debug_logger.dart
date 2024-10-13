

import 'package:flutter/foundation.dart' show debugPrint;

class DebugLog {

 final String context;
  final String message;

  DebugLog(this.context, this.message){
    debugPrint("$context: $message");
  }

}