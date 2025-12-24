/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file category_model.dart is part of kilobyte
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

class Category {
  final int? categoryId;
  final String categoryName;

  Category({this.categoryId, required this.categoryName});

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    categoryId: map['categoryId'],
    categoryName: map['categoryName'],
  );

  Map<String, dynamic> toMap() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
  };
}




