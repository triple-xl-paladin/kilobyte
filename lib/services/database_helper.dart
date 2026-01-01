/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file database_helper.dart is part of kilobyte
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

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:kilobyte/constants/app_constants.dart';
import 'package:kilobyte/models/item_model.dart';
import 'package:kilobyte/models/meal_item_model.dart';
import 'package:kilobyte/models/meal_model.dart';
import '../models/meal_item_view_model.dart';
import '../models/meal_with_items_model.dart';
import '../services/logging_service.dart';
import '../utils/debug_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

/// Implements all the database calls to record the meals and products
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static final String _dbName = AppConstants.dbName;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Delete the existing database for clean start (development only!)
    final dbFile = File(path);
    // kReleaseMode returns true if in release, thus !kReleaseMode returns true if in debug
    // Note:
    //  final sets the variable immutable at runtime
    //  const sets the variable immutable at compile time
    final bool isDebugMode = !kReleaseMode;

    if (await dbFile.exists() && isDebugMode) {
      LoggingService().info('Deleting existing database at $path');
      debugLog('Deleting existing database at $path');
      await dbFile.delete();
    }
    // ends here

    LoggingService().info('${DateTime.now()}: Database to be loaded $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Create all the tables
  ///
  Future _createDB(Database db, int version) async {
    LoggingService().info('${DateTime.now()}: Database tables to be created');

    /// Create item table
    await db.execute('''
      CREATE TABLE products (
        productId INTEGER PRIMARY KEY AUTOINCREMENT,
        ean INTEGER,
        name TEXT,
        calories REAL,
        fat REAL,
        carbs REAL,
        protein REAL,
        salt REAL,
        sugar REAL,
        lastUsed DATETIME,
        frequency INTEGER
      )
    ''');

    /// Create meal entry table
    await db.execute('''
      CREATE TABLE meal (
        mealId INTEGER PRIMARY KEY AUTOINCREMENT,
        mealName TEXT,
        mealDTTM DATETIME
      )
    ''');

    /// Create meal items table
    await db.execute('''
      CREATE TABLE mealItems (
        mealItemId INTEGER PRIMARY KEY AUTOINCREMENT,
        mealId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY(mealId) REFERENCES meal(mealId) ON DELETE CASCADE,
        FOREIGN KEY(productId) REFERENCES products(productId) ON DELETE CASCADE
      )
    ''');

    /// Create favourite products table
    await db.execute('''
    CREATE TABLE favouriteProducts (
        productId INTEGER PRIMARY KEY,
        addedDTTM DATETIME,
        FOREIGN KEY(productId) REFERENCES products(productId) ON DELETE CASCADE
    );
    ''');


    LoggingService().info('${DateTime.now()}: Database tables created');
  }

  /// Delete the database
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Delete the existing database for clean start
    final dbFile = File(path);

    if (await dbFile.exists()) {
      LoggingService().info('${DateTime.now()}: Deleting existing database at $path');
      await dbFile.delete();
    }

    // Also clear the cached _database instance so it reopens fresh next time
    _database = null;
  }

  // CRUD operations here...

  /// Insert a product into the database
  /// Returns the ID of the inserted product
  Future<int> insertProduct(ItemModel product) async {
    try {
      final db = await instance.database;
      final id = await db.insert('products', {
        'name': product.name,
        'calories': product.calories,
        'ean': product.ean,
        'fat': product.fat,
        'carbs': product.carbs,
        'protein': product.protein,
        'salt': product.salt,
        'sugar': product.sugar,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
      return id;
    } catch (e, s) {
      LoggingService().info('${DateTime.now()}: DB error, adding product failed with $e $s');
      debugLog('DB error, manual phasing insert failed with $e $s');
      return 0;
    }
  }

  Future<int> insertMeal(MealModel meal) async {
    try {
      final db = await instance.database;
      final id = await db.insert('meal', {
        'mealName': meal.meal.name,
        'mealDTTM': meal.mealDate.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.abort);
      return id;
    } catch (e, s) {
      LoggingService().info('${DateTime.now()}: DB error, adding meal failed with $e $s');
      debugLog('DB error, manual phasing insert failed with $e $s');
      return 0;
    }
  }

  /// Inserts items associated with a meal.
  /// [mealId] must exist
  /// [items] must not be empty
  Future<void> insertMealItems(int mealId, List<MealItemModel> items) async {
    if(items.isEmpty) return;

    try {
      final db = await instance.database;
      await db.transaction((txn) async {
        for (final item in items) {
          await txn.insert('mealItems', {
            'mealId': mealId,
            'productId': item.productId,
            'quantity': item.quantity,
            'unit': item.unit,
          },
            conflictAlgorithm: ConflictAlgorithm.abort,
          );
        }
      });
    } catch (e, s) {
      LoggingService().info('${DateTime.now()}: DB error, adding items to meal failed with $e $s');
      debugLog('DB error, insert items to meal failed with $e $s');
    }
  }

  /// Inserts a complete meal entry into the database.
  /// Returns the ID of the inserted meal.
  /// This replaces the individual insertions for efficiency.
  Future<int> insertMealWithItems(MealModel meal) async {
    final db = await database;
    int mealId = 0;

    await db.transaction((txn) async {
      // Insert the meal
      mealId = await txn.insert('meal', {
        'mealName': meal.meal.name,
        'mealDTTM': meal.mealDate.toIso8601String(),
      });

      // Insert each meal item
      for (final item in meal.items ?? []) {
        await txn.insert('mealItems', {
          'mealId': mealId,
          'productId': item.productId,
          'quantity': item.quantity,
          'unit': item.unit,
        });
      }
    });

    return mealId;
  }


  Future<MealWithItems?> getMealWithItems(int mealId) async {
    final db = await instance.database;

    final rows = await db.rawQuery('''
    SELECT
      m.mealId            AS meal_mealId,
      m.mealName          AS meal_mealName,
      m.mealDTTM          AS meal_mealDTTM,

      mi.mealItemId       AS item_mealItemId,
      mi.productId        AS item_productId,
      mi.quantity         AS item_quantity,
      mi.unit             AS item_unit,

      p.productId         AS product_productId,
      p.name              AS product_name,
      p.calories          AS product_calories,
      p.fat               AS product_fat,
      p.carbs             AS product_carbs,
      p.protein           AS product_protein,
      p.salt              AS product_salt,
      p.sugar             AS product_sugar
    FROM meal m
    JOIN mealItems mi ON mi.mealId = m.mealId
    JOIN products p   ON p.productId = mi.productId
    WHERE m.mealId = ?
    ORDER BY mi.mealItemId
  ''', [mealId]);

    if (rows.isEmpty) return null;

    // Build the MealModel (meal info)
    final meal = MealModel(
      mealId: rows.first['meal_mealId'] as int,
      meal: Meal.fromName(rows.first['meal_mealName'] as String),
      mealDate: DateTime.parse(rows.first['meal_mealDTTM'] as String),
      items: [], // We'll fill view models separately
    );

    // Build the list of MealItemViewModels
    final items = <MealItemViewModel>[];

    for (final row in rows) {
      final mealItem = MealItemModel(
        mealItemId: row['item_mealItemId'] as int,
        mealId: meal.mealId!,
        productId: row['item_productId'] as int,
        quantity: (row['item_quantity'] as num).toDouble(),
        unit: row['item_unit'] as String,
      );

      final product = ItemModel(
        productId: row['product_productId'] as int,
        name: row['product_name'] as String,
        calories: (row['product_calories'] as num?)?.toDouble(),
        fat: (row['product_fat'] as num?)?.toDouble(),
        carbs: (row['product_carbs'] as num?)?.toDouble(),
        protein: (row['product_protein'] as num?)?.toDouble(),
        salt: (row['product_salt'] as num?)?.toDouble(),
        sugar: (row['product_sugar'] as num?)?.toDouble(),
      );

      items.add(MealItemViewModel(
        mealItem: mealItem,
        product: product,
      ));
    }

    return MealWithItems(
      meal: meal,
      items: items,
    );
  }

  Future<List<ItemModel>> getRecentlyUsedProducts({int limit = 20}) async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT
      p.*,
      MAX(m.mealDTTM) AS lastUsed
    FROM mealItems mi
    JOIN meal m ON m.mealId = mi.mealId
    JOIN products p ON p.productId = mi.productId
    GROUP BY p.productId
    ORDER BY lastUsed DESC
    LIMIT ?
  ''', [limit]);

    return result.map(ItemModel.fromMap).toList();
  }

  Future<void> insertFavourite(ItemModel product) async {
    try {
      final db = await instance.database;
      await db.insert('favouriteProducts', {
        'productId': product.productId,
        'addedDTTM': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e, s) {
      LoggingService().info('${DateTime.now()}: DB error, adding favourite failed with $e $s');
      debugLog('DB error, adding favourite failed with $e $s');
    }
  }

  Future<void> deleteFavourites(ItemModel product) async {
    try {
      final db = await instance.database;
      await db.delete(
        'favouriteProducts',
        where: 'productId = ?',
        whereArgs: [product.productId],
      );
    } catch (e, s) {
      LoggingService().info('${DateTime.now()}: DB error, deleting favourite product failed with $e $s');
      debugLog('DB error, deleting favourite product failed with $e $s');
    }
  }

  Future<void> toggleFavourite(int productId) async {
    final db = await instance.database;

    final exists = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT 1 FROM favouriteProducts WHERE productId = ? LIMIT 1',
        [productId],
      ),
    );

    if (exists == null) {
      await insertFavouriteById(productId);
    } else {
      await deleteFavouriteById(productId);
    }
  }

  Future<void> insertFavouriteById(int productId) async {
    try {
      final db = await instance.database;

      await db.insert(
        'favouriteProducts',
        {
          'productId': productId,
          'addedDTTM': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e, s) {
      LoggingService().info(
        '${DateTime.now()}: DB error, adding favourite failed with $e $s',
      );
      debugLog('DB error, adding favourite failed with $e $s');
    }
  }

  Future<void> deleteFavouriteById(int productId) async {
    try {
      final db = await instance.database;

      await db.delete(
        'favouriteProducts',
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } catch (e, s) {
      LoggingService().info(
        '${DateTime.now()}: DB error, deleting favourite failed with $e $s',
      );
      debugLog('DB error, deleting favourite failed with $e $s');
    }
  }

  Future<List<int>> getFavouriteProductIds() async {
    final db = await instance.database;

    final result = await db.query(
      'favouriteProducts',
      columns: ['productId'],
    );

    return result
        .map((row) => row['productId'] as int)
        .toList();
  }

  Future<bool> isFavourite(int productId) async {
    final db = await instance.database;

    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT 1 FROM favouriteProducts WHERE productId = ? LIMIT 1',
        [productId],
      ),
    );

    return result != null;
  }


}
