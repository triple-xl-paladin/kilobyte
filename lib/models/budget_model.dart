/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file budget_model.dart is part of flutter_scaffold
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

enum PhasingType {twelfths,manual }

/// Represents a budget allocation for a specific category.
///
/// A 'Budget' defines the total amount planned for a category over a period of time,
/// along with how that amount is phased across months, quarters, or manually.
/// Each budget can optionally have a start and end date, and is linked to a
/// specific category by `categoryId`.
///
/// Fields:
/// - [budgetId]: Optional unique identifier (typically from the database).
/// - [categoryId]: The ID of the category this budget applies to.
/// - [totalAmount]: The total amount allocated for the budget.
/// - [startDate]: Optional start date of the budget period.
/// - [endDate]: Optional end date of the budget period.
/// - [phasingType]: How the budget is phased (monthly/quarterly/manual).
///
/// Includes utility methods:
/// - `fromMap(Map<String, dynamic>)` → creates a Budget object from a database row.
/// - `toMap()` → converts the Budget object to a map suitable for database storage.
class Budget {
  final int? budgetId;
  final int categoryId;
  final String? description;
  final double totalAmount;
  final String? startDate;
  final String? endDate;
  final PhasingType phasingType;

  /// Constructor
  Budget({
    this.budgetId,
    required this.categoryId,
    this.description,
    required this.totalAmount,
    this.startDate,
    this.endDate,
    required this.phasingType,
  });

  /// Convert a Map object to a Budget object
  factory Budget.fromMap(Map<String, dynamic> map) =>
      Budget(
        budgetId: map["id"],
        categoryId: map["categoryId"],
        description: map["description"],
        totalAmount: map["totalAmount"].toDouble(),
        startDate: map["startDate"],
        endDate: map["endDate"],
        phasingType: map["phasingType"],
      );

  /// Convert a Budget object to a Map object
  Map<String, dynamic> toMap() => {
    "id": budgetId,
    "categoryId": categoryId,
    "description": description,
    "totalAmount": totalAmount,
    "startDate": startDate,
    "endDate": endDate,
    "phasingType": phasingType,
  };

  /// Convert a String to a PhasingType
  static PhasingType _phasingFromString(String value) {
    switch (value) {
      case '12ths': return PhasingType.twelfths;
      //case 'quarters': return PhasingType.quarters; // Removed as year start and end date is arbitrary
      default: return PhasingType.manual;
    }
  }
}