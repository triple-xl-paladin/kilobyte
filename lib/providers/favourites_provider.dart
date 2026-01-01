/*
 * Copyright (c) 2026  Alexander Chen <aprchen@gmail.com>
 *
 * This file favourites_provider.dart is part of kilobyte
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
import '../services/database_helper.dart';

class FavouritesProvider extends ChangeNotifier {
  final DatabaseHelper _db;

  final Set<int> _favourites = {};

  FavouritesProvider(this._db);

  bool isFavourite(int productId) => _favourites.contains(productId);

  Set<int> get favourites => _favourites;

  Future<void> load() async {
    final ids = await _db.getFavouriteProductIds();
    _favourites
      ..clear()
      ..addAll(ids);
    notifyListeners();
  }

  Future<void> toggle(int productId) async {
    if (_favourites.contains(productId)) {
      await _db.deleteFavouriteById(productId);
      _favourites.remove(productId);
    } else {
      await _db.insertFavouriteById(productId);
      _favourites.add(productId);
    }
    notifyListeners();
  }
}
