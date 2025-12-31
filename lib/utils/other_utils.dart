/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file other_utils.dart is part of Stellar Quest
 *
 * Stellar Quest is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Stellar Quest is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Stellar Quest.  If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * This file is part of Stellar Quest.
 *
 * Stellar Quest is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Stellar Quest is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Stellar Quest.  If not, see <https://www.gnu.org/licenses/>.
 */

// lib/utils/other_utils.dart
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
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

// Extension to provide firstWhereOrNull, similar to Kotlin or C#
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

String capitalizeWords(String text) {
  return text
      .toLowerCase()
      .split(' ')
      .map((word) => word.isEmpty
      ? word
      : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

Future<String?> askString(BuildContext ctx, String title) async {
  String input = '';
  return showDialog<String>(
    context: ctx,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: TextField(onChanged: (v) => input = v),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, input), child: Text('OK')),
      ],
    ),
  );
}

/// Displays a dialog for text input and includes a button to generate a random string.
Future<String?> askStringWithRandomizer(BuildContext ctx, String title, Map<int, String> randomTable) async {
  final controller = TextEditingController();
  String input = '';
  final rand = Random();

  return showDialog<String>(
    context: ctx,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Row(
        children: [
          Expanded(child: TextField(controller: controller, onChanged: (v) => input = v)),
          const SizedBox(width: 8), // spacing between field and button
          ElevatedButton(
            onPressed: () {
              // Pick a random key from 1 to 20
              int key = rand.nextInt(randomTable.length) + 1; // 1..length
              debugLog('Random key: $key');
              controller.text = randomTable[key] ?? '';
              debugLog('Controller.text: ${controller.text}');
              input = controller.text; // keep input updated
            },
            child: const Icon(FontAwesomeIcons.diceD20),
          ),
        ]
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, input), child: Text('OK')),
      ],
    ),
  );
}


extension StringCaps on String {
  /// Capitalizes only the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Converts the string to Title Case (first letter of each word, handles hyphens/apostrophes)
  String toTitleCase() {
    if (isEmpty) return this;

    final smallWords = <String>{
      'a', 'an', 'and', 'as', 'at', 'but', 'by', 'for', 'if', 'in', 'nor',
      'of', 'on', 'or', 'the', 'to', 'vs', 'via'
    };

    final keepCaps = <String>{'USS','IKS','III'}; // add any words you always want fully uppercase

    final words = toLowerCase().split(' ');

    for (var i = 0; i < words.length; i++) {
      final word = words[i];

      // Preserve words in keepCaps list
      if (keepCaps.contains(word.toUpperCase())) {
        words[i] = word.toUpperCase();
        continue;
      }

      // Don't capitalize small words unless first or last
      if (i != 0 && i != words.length - 1 && smallWords.contains(word)) {
        words[i] = word;
        continue;
      }

      // Capitalize letters and handle hyphens/apostrophes
      words[i] = word.splitMapJoin(
        RegExp(r"[-']"),
        onMatch: (m) => m.group(0)!,
        onNonMatch: (segment) {
          if (segment.isEmpty) return '';
          return segment[0].toUpperCase() + segment.substring(1);
        },
      );
    }

    return words.join(' ');
  }

}

String timestampForFilename(DateTime dt) {
  return DateFormat('yyyy-MM-dd_HHmm').format(dt);
}

String normalisedDTTM(DateTime dt) {
  return DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
}


