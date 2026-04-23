import 'package:flutter/foundation.dart';

class DeviceInfo {
  static String getDevicePlatform() {
    return (kIsWeb) ? "Web" : "App";
  }
}
