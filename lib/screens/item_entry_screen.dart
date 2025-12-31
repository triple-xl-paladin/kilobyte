/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file item_entry_screen.dart is part of kilobyte
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
import '../models/item_model.dart';
import '../widgets/safe_scaffold_widget.dart';

class ItemEntryScreen extends StatefulWidget{
  const ItemEntryScreen({super.key});

  @override
  State<ItemEntryScreen> createState() => _ItemEntryScreenState();
}

class _ItemEntryScreenState extends State<ItemEntryScreen> {


  /*
  String name;
  double? calories;
  int? ean;
  double? fat;
  double? carbs;
  double? protein;
  double? salt;
  double? sugar;
   */
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(title: Text('Item Entry')),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                  labelText: 'Name',
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}