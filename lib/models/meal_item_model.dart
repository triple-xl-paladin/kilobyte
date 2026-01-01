/*
 * Copyright (c) 2026  Alexander Chen <aprchen@gmail.com>
 *
 * This file meal_item_model.dart is part of kilobyte
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

class MealItemModel {
  /// DB id for this meal item row
  final int? mealItemId;

  /// Owning meal
  final int? mealId;

  /// Product being consumed
  final int productId;

  /// How much was consumed
  final double quantity;

  /// Unit of measure (g, ml, piece, slice, etc)
  final String unit;

  MealItemModel({
    this.mealItemId,
    this.mealId,
    required this.productId,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toMap() => {
    'mealId': mealId,
    'productId': productId,
    'quantity': quantity,
    'unit': unit,
  };

  factory MealItemModel.fromMap(Map<String, dynamic> map) {
    return MealItemModel(
      mealItemId: map['mealItemId'] as int?,
      mealId: map['mealId'] as int,
      productId: map['productId'] as int,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
    );
  }
}
