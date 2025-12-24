/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file debug_test_screen.dart is part of kilobyte
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

/// The Character Sheet screen shows the details of the character. The
/// constructor expects a Character object.
class DebugTestScreen extends StatefulWidget {

  /// Constructor expects a Character object
  const DebugTestScreen({
    super.key,
  });

  @override
  State<DebugTestScreen> createState() => _DebugTestScreenState();
}

/// Private class that contains the layout and widgets for the character screen
class _DebugTestScreenState extends State<DebugTestScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Debug Test Screen"),
        ),
        body:
        /*
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Placeholder(),
            ], // children
          ),
        ),
        */
        Padding (
          padding: const EdgeInsets.all(16.0),
          child: Placeholder(),
        ),
    );
  } // build
}