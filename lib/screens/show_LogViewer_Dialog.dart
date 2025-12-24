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
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> showLogViewerDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return FutureBuilder<String>(
        future: _loadLogFile(),
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

Future<String> _loadLogFile() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/daggerheart.log');
    if (!await file.exists()) {
      String msg = 'Log file not found.';
      debugPrint('${DateTime.now()}: $msg');
      return msg;
    }
    return await file.readAsString();
  } catch (e) {
    String msg = 'Failed to load log: $e';
    debugPrint('${DateTime.now()}: $msg');
    return msg;
  }
}
