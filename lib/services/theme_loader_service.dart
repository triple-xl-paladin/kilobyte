/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file theme_loader_service.dart is part of kilobyte
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

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../utils/other_utils.dart';

class ThemeLoader {
  static Map<String, String> themeManifest = {};

  static Future<ThemeData> loadThemeFromJson(String path) async {
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> data = json.decode(jsonStr);
    return _parseThemeFromJson(data);
  }

  static Future<Map<String, ThemeData>> loadThemesFromManifest() async {
    final manifestString = await rootBundle.loadString(
        'assets/themes/theme_manifest.json');
    final manifest = jsonDecode(manifestString) as Map<String, dynamic>;

    themeManifest =
        manifest.map((key, value) => MapEntry(key, 'assets/themes/$value'));

    final Map<String, ThemeData> loadedThemes = {};
    for (final entry in themeManifest.entries) {
      final jsonString = await rootBundle.loadString(entry.value);
      final themeData = _parseThemeFromJson(json.decode(jsonString));
      loadedThemes[entry.key] = themeData;
    }

    return loadedThemes;
  }

  /// Load a theme based on the name of the theme
  static Future<ThemeData> loadThemeByName(String name) async {
    if (themeManifest.isEmpty) {
      await loadThemesFromManifest(); // Populate themeManifest if it's not already loaded
    }

    final path = themeManifest[name];
    if (path == null) {
      throw Exception("Theme '$name' not found in manifest.");
    }

    return await loadThemeFromJson(path);
  }

  static ThemeData _parseThemeFromJson(Map<String, dynamic> json) {
    return ThemeData(
      brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
      primaryColor: hexToColor(json['primaryColor']),
      scaffoldBackgroundColor: hexToColor(json['scaffoldBackgroundColor']),
      cardColor: hexToColor(json['cardColor']),
      appBarTheme: AppBarTheme(
        backgroundColor: hexToColor(json['appBarBackgroundColor']),
        foregroundColor: hexToColor(json['appBarForegroundColor']),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: hexToColor(json['textColor'])),
        titleLarge: TextStyle(
          color: hexToColor(json['titleColor']),
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: hexToColor(json['iconColor'])),
      fontFamily: json['fontFamily'] ?? 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: hexToColor(json['primary']),
        brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
        primary: hexToColor(json['primary']),
        secondary: hexToColor(json['secondary']),
      ),
    );
  }
}
