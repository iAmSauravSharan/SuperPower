import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

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
