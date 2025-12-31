/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file item_model.dart is part of kilobyte
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

class ItemModel {
  String name;
  double? calories;
  int? ean;
  double? fat;
  double? carbs;
  double? protein;
  double? salt;
  double? sugar;

  ItemModel({
    required this.name,
    this.ean,
    this.fat,
    this.carbs,
    this.protein,
    this.salt,
    this.sugar,
    this.calories,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) =>
    ItemModel(
      name: map['name'],
      ean: map['ean'],
      fat: map['fat'],
      carbs: map['carbs'],
      protein: map['protein'],
      salt: map['salt'],
      sugar: map['sugar'],
      calories: map['calories'],
    );

  Map<String, dynamic> toMap() => {
    'name': name,
    'ean': ean,
    'fat': fat,
    'carbs': carbs,
    'protein': protein,
    'salt': salt,
    'sugar': sugar,
    'calories': calories,
  };
}