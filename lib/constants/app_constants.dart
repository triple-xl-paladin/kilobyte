
/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file app_constants.dart is part of kilobyte
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

/// Represents the type of meal.
///
/// The enum [name] is used for persistence and must remain stable.
/// The [label] is for display purposes only and may be localised.
///
/// IMPORTANT:
/// Do not persist [Meal.label].
/// Only [Meal.name] is stored in the database.
enum Meal {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  other('Other');

  /// User-facing display label.
  final String label;

  const Meal(this.label);

  static Meal fromName(String name) => Meal.values.firstWhere((e) => e.name == name);

  static Meal fromLabel(String label) => Meal.values.firstWhere((e) => e.label == label);

  static final List<String> mealLabels = [
    Meal.breakfast.label,
    Meal.lunch.label,
    Meal.dinner.label,
    Meal.other.label
  ];

}

extension MealExtension on Meal {
  String get label {
    switch (this) {
      case Meal.breakfast: return 'Breakfast';
      case Meal.lunch:     return 'Lunch';
      case Meal.dinner:    return 'Dinner';
      case Meal.other:     return 'Other';
    }
  }
}

class AppConstants {
  static final String appName = 'Kilobyte';
  static final String dbName = 'kilobyte.db';
}