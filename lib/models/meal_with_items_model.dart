/*
 * Copyright (c) 2026  Alexander Chen <aprchen@gmail.com>
 *
 * This file meal_with_items_model.dart is part of kilobyte
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

import 'meal_item_view_model.dart';
import 'meal_model.dart';

/// This is a presentation helper
/// A wrapper that holds pre-joined view models for display
class MealWithItems {
  final MealModel meal;
  final List<MealItemViewModel> items;

  MealWithItems({
    required this.meal,
    required this.items,
  });
}
