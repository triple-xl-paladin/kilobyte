import 'package:package_info_plus/package_info_plus.dart';
import 'dart:ui';
import 'debug_utils.dart';

/// Safely parses a dynamic value to an int.
///
/// If [value] is already an [int], it's returned directly.
/// If [value] is a [String], it attempts to parse it to an [int].
/// If parsing fails or [value] is neither an [int] nor a [String],
/// [fallback] (defaulting to 0) is returned.
int parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

// You can add other parsing helpers here
// double parseDouble(dynamic value, {double fallback = 0.0}) { ... }
// bool parseBool(dynamic value, {bool fallback = false}) { ... }

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}

Future<String> getBuildVersionString() async {
  final info = await PackageInfo.fromPlatform();
  final versionStr = 'Version ${info.version} (Build ${info.buildNumber})';
  debugLog("Build Info: $versionStr");
  return versionStr;
}