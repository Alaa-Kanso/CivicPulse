import 'dart:io';

import 'package:flutter/foundation.dart';

class DeviceInfo {
  static String getDevicePlatform() {
    if (kIsWeb) return "Web";
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "IOS";
    if (Platform.isWindows) return "Windows";
    if (Platform.isMacOS) return "MacOS";
    if (Platform.isLinux) return "Linux";
    return "Unknown";
  }
}