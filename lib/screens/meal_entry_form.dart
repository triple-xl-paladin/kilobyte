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
import '../constants/app_constants.dart';

class MealEntryForm extends StatefulWidget{
  const MealEntryForm({super.key});

  @override
  State<MealEntryForm> createState() => _MealEntryFormState();

}

class _MealEntryFormState extends State<MealEntryForm> {

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
              _mealView(context),
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
      height: 250,
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
          Icon(MdiIcons.barcodeScan, size: 52,),
        ],
      ),
    );
  }

  // View the current items in the meal and total calorie tally
  Widget _mealView(BuildContext context) {
    return Container();
  }
}