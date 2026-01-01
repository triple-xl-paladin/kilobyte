/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file show_LogViewer_Dialog.dart is part of kilobyte
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

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/logging_service.dart';

Future<void> showLogViewerDialog(BuildContext context) async {
  final loggingService = LoggingService(); // or inject if you're using DI

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return FutureBuilder<String>(
        future: loggingService.loadLogContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('View Logs'),
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          } else {
            final logContent = snapshot.data ?? 'No logs available.';
            return AlertDialog(
              title: Text('View Logs'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      logContent,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => exportLogsToFile(dialogContext, logContent),
                  child: const Text('Export'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          }
        },
      );
    },
  );
}

Future<void> exportLogsToFile(
    BuildContext context,
    String logContent,
    ) async {
  try {
    final String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Export logs',
      fileName: 'app_logs.txt',
      type: FileType.custom,
      allowedExtensions: ['txt', 'log'],
    );

    if (outputPath == null) return; // user cancelled

    final file = File(outputPath);
    await file.writeAsString(logContent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs exported successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to export logs: $e')),
    );
  }
}