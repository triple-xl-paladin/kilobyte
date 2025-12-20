import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

void debugLog(String message) {
  if (kDebugMode) {
    print('[DEBUG] $message');
  }
}

Future<void> resetThemeOnStartup(Box settingsBox) async {
  if (kDebugMode) {
    await settingsBox.clear();
  }
}
