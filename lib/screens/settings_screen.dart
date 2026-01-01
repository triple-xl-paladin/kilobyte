/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file settings_screen.dart is part of kilobyte
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

import '../screens/show_log_viewer_dialog.dart';
import '../services/theme_loader_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_helper.dart';
import '../providers/theme_provider.dart';
import 'dart:async';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String gplNotice = '''
This app is licensed under the GNU General Public License (GPL) version 3 or later.
You can find the full license text at: https://www.gnu.org/licenses/gpl-3.0.html
''';

  bool _themesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadThemeManifest();
  }

  Future<void> _loadThemeManifest() async {
    await ThemeLoader.loadThemesFromManifest();
    setState(() {
      _themesLoaded = true;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open URL')),
      );
    }
  }

  void _viewLogs() {
    showLogViewerDialog(context);
    /*
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View logs clicked')),
    );
     */
  }

  void _importData() {
    // TODO: Implement your import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Import clicked')),
    );
  }

  void _exportData() {
    // TODO: Implement your export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export clicked')),
    );
  }

  void _showResetDialog(BuildContext context) {
    int countdown = 5;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start timer only once
            timer ??= Timer.periodic(const Duration(seconds:1), (t) {
              if(countdown == 1) {
                t.cancel();
              }
              setState(() {
                countdown--;
              });
            });

            final confirmEnabled = countdown <= 0;

            return AlertDialog(
              title: const Text('Confirm Reset'),
              content: Text(
                confirmEnabled
                    ? 'Are you sure you want to reset the database? This cannot be undone.'
                    : 'This will delete all characters and cards.\n\nYou can confirm in $countdown seconds.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: confirmEnabled
                      ? () async {
                    await DatabaseHelper.instance.resetDatabase();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Database reset successfully'),
                        ),
                      );
                    }
                  }
                      : null,
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    //final currentTheme = themeProvider.themeData;
    final box = Hive.box('settings');

    if (!_themesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    //final String currentThemeKey = box.get('selectedThemeKey', defaultValue: 'Dark Fantasy');
    final savedKey = box.get('selectedThemeKey', defaultValue: '');
    final currentThemeKey = savedKey.isEmpty ? null : savedKey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme toggle
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            subtitle: DropdownButtonFormField<String>(
              initialValue: currentThemeKey,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child:  Text("Default (Flutter Light)"),
                ),
                ...ThemeLoader.themeManifest.keys.map((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }),
              ],
              onChanged: (selectedKey) async {
                if (selectedKey == null) {
                  // Default theme
                  themeProvider.setTheme(ThemeData.light());

                  // Save default theme key to Hive
                  await box.put('selectedThemeKey', '');
                } else {
                  final selectedTheme = await ThemeLoader.loadThemeFromJson(
                    ThemeLoader.themeManifest[selectedKey]!,
                  );
                  themeProvider.setTheme(selectedTheme);

                  // Save selected theme key to Hive
                  await box.put('selectedThemeKey', selectedKey);
                } // if
              }, // onChanged
            ),
          ),
          const Divider(),

          // Import / Export
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Data WIP'),
            onTap: _importData,
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Data WIP'),
            onTap: _exportData,
          ),
          const Divider(),

          // View logs
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('View Logs'),
            onTap: _viewLogs,
          ),
          const Divider(),

          // Reset Database
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text('Reset Database'),
            subtitle: const Text('Deletes all cards and characters'),
            onTap: () => _showResetDialog(context),
          ),
          const Divider(),

         // GPL Section
          Text(
            'GNU General Public License (GPL) - App Code',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(gplNotice),
          TextButton(
            onPressed: () => _launchUrl('https://www.gnu.org/licenses/gpl-3.0.html'),
            child: const Text('View GPL License Online'),
          ),
        ],
      ),
    );
  }
}