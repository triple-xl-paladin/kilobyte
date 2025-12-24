/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file logging_service.dart is part of kilobyte
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
import '../utils/debug_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();

  factory LoggingService() => _instance;

  late Logger rootLogger;
  IOSink? _logFileSink;

  LoggingService._internal();

  Future<void> setup({Level level = Level.ALL}) async {
    Logger.root.level = level;

    // Setup file for logging
    final logFile = await _initLogFile();
    _logFileSink = logFile.openWrite(mode: FileMode.append);

    Logger.root.onRecord.listen((record) {
      final logMessage =
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}';

      // Print to console
      debugLog('LoggingService: $logMessage');

      // Write to log file
      _logFileSink?.writeln(logMessage);
    });

    rootLogger = Logger('Root');

    rootLogger.info('${DateTime.now()} LoggingService initialised and log file: ${logFile.path}');
  }

  Logger getLogger(String name) => Logger(name);

  // Convenience methods for logging at root level
  void info(String message) => rootLogger.info(message);
  void warning(String message) => rootLogger.warning(message);
  void severe(String message) => rootLogger.severe(message);

  Future<void> close() async {
    await _logFileSink?.flush();
    await _logFileSink?.close();
  }

  Future<File> _initLogFile() async {
    Directory directory;

    if (Platform.isAndroid || Platform.isIOS) {
      directory = await getTemporaryDirectory(); // cache directory
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      directory = await getApplicationDocumentsDirectory(); // persistent directory
    } else {
      debugPrint("LoggingService: Unsupported platform");
      throw UnsupportedError("Unsupported platform");
    }

    //final directory = await getApplicationDocumentsDirectory(); // Or use a specific directory if desired
    final logFile = File('${directory.path}/my-money.log');

    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }

    return logFile;
  }

}
