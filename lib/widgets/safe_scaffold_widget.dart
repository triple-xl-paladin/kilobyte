/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file safe_scaffold_widget.dart is part of Stellar Quest
 *
 * Stellar Quest is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Stellar Quest is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Stellar Quest.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;

  const SafeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(child: bottomNavigationBar!)
          : null,
      bottomSheet: bottomSheet != null
          ? SafeArea(child: bottomSheet!)
          : null,
      endDrawer: endDrawer != null
          ? SafeArea(child: endDrawer!)
          : null,
    );
  }
}
