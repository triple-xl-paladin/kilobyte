/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file export_helper.dart is part of Stellar Quest
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

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class ExportHelper {
  /// Exports any text content to a file safely across platforms.
  ///
  /// [fileName] should include the desired extension (e.g., 'characters.json', 'session.md').
  /// [textContent] is the string data to save.
  /// [dialogTitle] is optional for the FilePicker dialog.
  static Future<bool> exportTextFile({
    required String fileName,
    required String textContent,
    String dialogTitle = 'Save file',
    List<String>? allowedExtensions,
  }) async {
    try {
      // Convert text to bytes (UTF-8) for Android-safe writing
      final bytes = Uint8List.fromList(utf8.encode(textContent));

      await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        bytes: bytes, // ✅ Android-safe
      );

      // Returns true if the user saved the file (note: cannot detect cancel reliably)
      return true;
    } catch (_) {
      // Could log error here if needed
      return false;
    }
  }
}
