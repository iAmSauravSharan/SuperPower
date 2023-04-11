import 'dart:io';
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

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

Future<String> getIpAddress() async {
  for (var interface in await NetworkInterface.list()) {
    for (var address in interface.addresses) {
      if (address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }

  return '';
}

String getDeviceType() {
  if (Platform.isAndroid) return "Android";
  else if (Platform.isIOS) return "IOS";
  else if (Platform.isMacOS) return "MacOS";
  else if (Platform.isWindows) return "Windows";
  else if (Platform.isLinux) return "Linux";
  else return "Fuchsia";
}
