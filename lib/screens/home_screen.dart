/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file home_screen.dart is part of flutter_scaffold
 *
 * flutter_scaffold is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * flutter_scaffold is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with flutter_scaffold.  If not, see <https://www.gnu.org/licenses/>.
 */

import '../screens/debug_test_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/sidebar_menu.dart';
import '../widgets/feature_grid_tile.dart';

import '../screens/debug_database_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedContent = Placeholder(); // default content
  bool _isDarkMode = false;

  void _setContent(Widget content) {
    setState(() {
      _selectedContent = content;
    });
  }

  void _handleThemeChanged(bool newValue) {
    setState(() {
      _isDarkMode = newValue;
    });
  }

  final List<Map<String, dynamic>> features = [];

  @override
  void initState() {
    super.initState();
    features.addAll([
      {
        'title': 'Item1',
        'icon': Icons.style,
        'content': Placeholder(),
      },
      {
        'title': 'Item2',
        'icon': Icons.people,
        'content': Placeholder(),
      },
      {
        'title': 'Item3',
        'icon': FontAwesomeIcons.hammer,
        'content': Placeholder(),
      },
    ]);

    if (kDebugMode) {
      features.add({
        'title': 'Debug Database',
        'icon': Icons.bug_report,
        'content': DebugDatabaseScreen(),
      });
      features.add({
        'title': 'Debug Screen Test',
        'icon': Icons.bug_report,
        'content': DebugTestScreen(),
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider to force initialization
    //final appData = Provider.of<AppDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('My App')),
      drawer: SidebarMenu(
        features: features,
        onSelectContent: _setContent,
        isDarkMode: _isDarkMode,
        onThemeChanged: _handleThemeChanged,
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedContent is Placeholder
                ? GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              children: features.map((feature) {
                return FeatureGridTile(
                  title: feature['title'],
                  icon: feature['icon'],
                  onTap: () => _setContent(feature['content']),
                );
              }).toList(),
            )
                : _selectedContent,
          ),
        ],
      ),
    );
  }
}
