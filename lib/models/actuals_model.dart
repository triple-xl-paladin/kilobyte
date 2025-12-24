/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file actuals_model.dart is part of kilobyte
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

class Actual {
  final int? actualId;
  final String date;
  final int? payeeId;
  final int? categoryId;
  final String? description;
  final double amount;

  Actual({
    this.actualId,
    required this.date,
    this.payeeId,
    this.categoryId,
    this.description,
    required this.amount,
  });

  factory Actual.fromMap(Map<String, dynamic> map) => Actual(
    actualId: map['id'],
    date: map['date'],
    payeeId: map['payee_id'],
    categoryId: map['category_id'],
    description: map['description'],
    amount: map['amount'],
  );

  Map<String, dynamic> toMap() => {
    'id': actualId,
    'date': date,
    'payee_id': payeeId,
    'category_id': categoryId,
    'description': description,
    'amount': amount,
  };
}
