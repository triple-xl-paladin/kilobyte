/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file manual_phasing_model.dart is part of flutter_scaffold
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

class ManualPhasing {
  final int? manualPhasingId;
  final int budgetId;
  final int month;
  final double amount;

  ManualPhasing({
    this.manualPhasingId,
    required this.budgetId,
    required this.month,
    required this.amount,
  });

  factory ManualPhasing.fromMap(Map<String, dynamic> map) => ManualPhasing(
    manualPhasingId: map['id'],
    budgetId: map['budget_id'],
    month: map['month'],
    amount: map['amount'],
  );

  Map<String, dynamic> toMap() => {
    'id': manualPhasingId,
    'budget_id': budgetId,
    'month': month,
    'amount': amount,
  };
}
