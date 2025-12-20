/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file payee_model.dart is part of flutter_scaffold
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

class Payee {
  final int? payeeId;
  final String payeeName;

  Payee({this.payeeId, required this.payeeName});

  factory Payee.fromMap(Map<String, dynamic> map) => Payee(
    payeeId: map['payeeId'],
    payeeName: map['payeeName'],
  );

  Map<String, dynamic> toMap() => {
    'payeeId': payeeId,
    'payeeName': payeeName,
  };
}
