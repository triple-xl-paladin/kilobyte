/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file sidebar_menu.dart is part of kilobyte
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

import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import 'package:kilobyte/utils/other_utils.dart';

class SidebarMenu extends StatefulWidget {
  final bool isDarkMode;
  final void Function(bool) onThemeChanged;
  final List<Map<String, dynamic>> features;

  const SidebarMenu({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.features,
    super.key,
  });

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();

}

class _SidebarMenuState extends State<SidebarMenu> {
  String _versionString = '';

  @override
  void initState() {
    super.initState();
    getBuildVersionString().then((str) {
      setState(() {
        _versionString = str;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded (
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.grid_view),
                    title: Text('Home'),
                    // Leave this as Placeholder as it will reset the screen to home
                    // If it points to homescreen, it will keep recreating the screen
                    // within the homescreen, duplicating everything.
                    onTap: () => Navigator.pop(context),
                  ),
                  ...widget.features.map((feature)
                  {
                    return ListTile(
                        leading: Icon(feature['icon']),
                        title: Text(feature['title']),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => feature['content']()),
                          );
                        }
                    );
                  }),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap:() {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                          SettingsScreen(
                            isDarkMode: widget.isDarkMode,
                            onThemeChanged: widget.onThemeChanged,
                          ),
                        ),
                      );
                    }
                  ),
                ], // Children in expanded
              ),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _versionString.isNotEmpty ? _versionString:'Loading version...',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ], // Children in column
        ),
      ),
    );
  }
}
