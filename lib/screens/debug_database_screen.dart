/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file debug_database_screen.dart is part of kilobyte
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
import '../services/database_helper.dart';
import '../utils/debug_utils.dart';

class DebugDatabaseScreen extends StatefulWidget {
  const DebugDatabaseScreen({super.key});

  @override
  State<DebugDatabaseScreen> createState() => _DebugDatabaseScreenState();
}

class _DebugDatabaseScreenState extends State<DebugDatabaseScreen> {
  Map<String, List<Map<String, dynamic>>> _tablesData = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTables();
  }

  Future<void> _loadAllTables() async {
    final db = await DatabaseHelper.instance.database;

    // Get all table names
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    Map<String, List<Map<String, dynamic>>> data = {};

    for (final table in tables) {
      final tableName = table['name'] as String;

      // Query all rows for this table
      final rows = await db.query(tableName);
      if (rows.isNotEmpty) {
        debugLog('Table $tableName has columns: ${rows.first.keys.join(', ')}');
      }
      data[tableName] = rows;
    }

    setState(() {
      _tablesData = data;
      _loading = false;
    });
  }

  Widget _buildTableView(String tableName, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return Text('No rows in $tableName');
    }

    // Get all column names from first row keys
    final columns = rows.first.keys.toList();

    // Calculate minimum width needed (e.g., 150 per column)
    final minWidth = columns.length * 150.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(150),
                border: TableBorder.all(),
                children: [
                  // Header row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.transparent),
                    children: columns.map((col) => Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(col, style: TextStyle(fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                // Data rows
                  for (final row in rows)
                    TableRow (
                      children: columns.map((col) => Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(row[col]?.toString() ?? 'null'),
                      )).toList(),
                    ),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Debug Database')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /*
    return Scaffold(
      appBar: AppBar(title: Text('Debug Database')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _tablesData.entries.map((entry) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  _buildTableView(entry.key, entry.value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = true;
          });
          _loadAllTables();
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );*/
    return Scaffold(
      appBar: AppBar(title: Text('Debug Database')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _tablesData.entries.map((entry) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth,
                          ),
                          child: _buildTableView(entry.key, entry.value),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = true;
          });
          _loadAllTables();
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
