/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file other_utils.dart is part of kilobyte
 *
 * kilobyte is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * kilobyte is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with kilobyte.  If not, see <https://www.gnu.org/licenses/>.
 */

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