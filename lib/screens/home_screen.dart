/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file home_screen.dart is part of kilobyte
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

import 'package:kilobyte/constants/app_constants.dart';
import 'package:kilobyte/widgets/safe_scaffold_widget.dart';
import '../screens/debug_test_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/feature_grid_tile.dart';
import '../screens/debug_database_screen.dart';
import '../widgets/vertical_progress_bar_chart.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

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
        'title': 'Breakfast',
        'icon': FontAwesomeIcons.egg,
        'content': () => Placeholder(),
      },
      {
        'title': 'Lunch',
        'icon': FontAwesomeIcons.burger,
        'content': () => Placeholder(),
      },
      {
        'title': 'Dinner',
        'icon': FontAwesomeIcons.bowlRice,
        'content': () => Placeholder(),
      },
      {
        'title': 'Other',
        'icon': FontAwesomeIcons.apple,
        'content': () => Placeholder(),
      },
    ]);

    if (kDebugMode) {
      features.add({
        'title': 'Debug Database',
        'icon': Icons.bug_report,
        'content': () => DebugDatabaseScreen(),
      });
      features.add({
        'title': 'Debug Screen Test',
        'icon': Icons.bug_report,
        'content': () => DebugTestScreen(),
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider to force initialization
    //final appData = Provider.of<AppDataProvider>(context, listen: false);

    return SafeScaffold(
      appBar: AppBar(title: Text(AppConstants.appName)),
      drawer: SidebarMenu(
        features: features,
        isDarkMode: _isDarkMode,
        onThemeChanged: _handleThemeChanged,
      ),
      body: Column(
        children: [
          _header(context),
          _mealButtons(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 250,
      // Reminder: [VerticalProgressBarChart] is a custom widget
      child: VerticalProgressBarChart(),
    );
  }

  Widget _mealButtons(BuildContext context) {
    return Expanded(
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          children: features.map((feature) {
            // Reminder: [FeatureGridTile] is a custom widget
            return FeatureGridTile(
              title: feature['title'],
              icon: feature['icon'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feature['content']()), // This is a map
                );
              },
            );
          }).toList(),
        )
    );
  }
}
