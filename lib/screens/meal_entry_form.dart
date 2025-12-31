/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file meal_entry_form.dart is part of kilobyte
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
import 'package:kilobyte/constants/app_constants.dart';
import 'package:kilobyte/widgets/safe_scaffold_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MealEntryForm extends StatefulWidget{
  const MealEntryForm({super.key});

  @override
  State<MealEntryForm> createState() => _MealEntryFormState();

}

class _MealEntryFormState extends State<MealEntryForm> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final navRails = [
    NavigationRailDestination(
      icon: Icon(Icons.schedule),
      label: Text('Recent'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.star),
      label: Text('Favourites'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: navRails.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(title: Text('Meal Entry')),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              _header(context),
              Expanded(child: _mealView(context),)
            ],
          ),
        )
      )
    );
  }

  // Contains the dropdown box of the current meal (e.g. lunch)
  // A search item textfield/textform
  // And a scanner button using Icons(Icon.barcodeScanner)
  Widget _header(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 70,
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TODO: Dropdown
          DropdownMenu(
            initialSelection: Meal.mealLabels[0],
              dropdownMenuEntries: <DropdownMenuEntry>[
                DropdownMenuEntry(
                  value: 1, label: Meal.mealLabels[0],
                ),
                DropdownMenuEntry(
                  value: 1, label: Meal.mealLabels[1],
                ),
                DropdownMenuEntry(
                  value: 1, label: Meal.mealLabels[2],
                ),
                DropdownMenuEntry(
                  value: 1, label: Meal.mealLabels[3],
                ),
              ],
          ),
          // TODO: Search field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                labelText: 'Search'
              )
            ),
          ),
          // TODO: Scanner button
          ElevatedButton(
            onPressed: () {
              // TODO: Implement camera function
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                // Make the button more square
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Icon(MdiIcons.barcodeScan, size: 52,)
          ),
        ],
      ),
    );
  }

  // View the current items in the meal and total calorie tally
  Widget _mealView(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NavigationRail(
            selectedIndex: _tabController.index.clamp(0, navRails.length-1),
            onDestinationSelected: (index) {
              _tabController.animateTo(index);
            },
            labelType: NavigationRailLabelType.none,
            destinations: navRails,
          ),
          const VerticalDivider(width: 1),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(), // disables swipe
              children: [
                Center(child: Text('Recent')),
                Center(child: Text('Favourites')),
              ],
            ),
          ),
        ],
      ),
    );
  }

}