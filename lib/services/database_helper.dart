/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file database_helper.dart is part of flutter_scaffold
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

import 'dart:async';
import '../models/budget_model.dart';
import '../models/actuals_model.dart';
import '../models/manual_phasing_model.dart';
import '../models/payee_model.dart';
import '../models/category_model.dart';
import '../services/logging_service.dart';
import '../utils/debug_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
//import 'package:flutter/foundation.dart';
import '../utils/other_utils.dart';

/// Example database implementation for a simple budget and expenditure
/// tracking app.

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static final String _dbName = 'my_money.db';

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
    /*
    bool resetDatabase = !kReleaseMode;
    final dbFile = File(path);
    if (await dbFile.exists()) {
      print('Deleting existing database at $path');
      await dbFile.delete();
    }
     */

    LoggingService().info('${DateTime.now()}: Database to be loaded $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }


  /// Create all the tables
  ///
  Future _createDB(Database db, int version) async {
    LoggingService().info('${DateTime.now()}: Database tables to be created');

    // Create budget table
    await db.execute('''
      CREATE TABLE budgets (
        budgetId INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryId INTEGER,
        description TEXT,
        startDate TEXT,
        endDate TEXT,
        totalAmount REAL,
        phasingType TEXT,
        FOREIGN KEY(categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryName TEXT
      )
    ''');

    /// Create actual table
    await db.execute('''
      CREATE TABLE actual (
        actualId INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        payeeId INTEGER,
        categoryId INTEGER,
        description TEXT,
        amount REAL,
        FOREIGN KEY(payeeId) REFERENCES payees(payeeId) ON DELETE CASCADE,
        FOREIGN KEY(categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE
      )
    ''');

    /// Create payees table
    await db.execute('''
      CREATE TABLE payee (
        payeeId INTEGER PRIMARY KEY AUTOINCREMENT,
        payeeName TEXT
      )
    ''');

    /// Create manual phasing table
    await db.execute('''
      CREATE TABLE manual_phasing (
        manualPhasingId INTEGER PRIMARY KEY AUTOINCREMENT,
        budgetId INTEGER,
        month INTEGER,
        amount REAL,
        FOREIGN KEY(budgetId) REFERENCES budgets(budgetId) ON DELETE CASCADE
      )
    ''');

    LoggingService().info('${DateTime.now()}: Database tables created');
  }

  // CRUD operations here...

  /// Insert budgets into the database
  /// If the budget is set to manual, it will also insert the manual phasing
  ///
  /// Returns the ID of the inserted budget
  Future<int> insertBudget(Budget budget, ManualPhasing? manualPhasing) async {
    try {
      final db = await instance.database;
      final id = await db.insert('budget', {
        'description': budget.description,
        'categoryId': budget.categoryId,
        'startDate': budget.startDate,
        'endDate': budget.endDate,
        'totalAmount': budget.totalAmount,
        'phasingType': budget.phasingType.toString(),
      }, conflictAlgorithm: ConflictAlgorithm.abort);

      if (budget.phasingType == PhasingType.manual && manualPhasing != null) {
          await db.insert('manual_phasing', {
            'budgetId': id,
            'month': manualPhasing.month,
            'amount': manualPhasing.amount,
          });
      }

      return id;

    } catch (e) {
      LoggingService().info('${DateTime.now()}: DB error, manual phasing insert failed with $e');
      debugLog('DB error, manual phasing insert failed with $e');
      return 0;
    }
  }

  /// Get budgets from the database
  ///
  /// Returns a list of budgets
  Future<List<Budget>> getBudgets() async {
    try {
      final db = await instance.database;

      final budgetRows = await db.query('budgets');

      return budgetRows.map((row) => Budget.fromMap(row)).toList();
    } catch(e) {
      LoggingService().info('${DateTime.now()}: DB error, get budgets failed with $e');
      debugLog('DB error, get budgets failed with $e');
      return [];
    }
  }

  /// Update a budget in the database
  Future<void> updateBudget(Budget budget) async {
    final db = await instance.database;
    await db.update('budgets', budget.toMap(), where: 'budgetId = ?', whereArgs: [budget.budgetId]);
  }

  /// Delete a budget from the database
  Future<void> deleteBudget(int budgetId) async {
    final db = await instance.database;
    await db.delete('budgets', where: 'budgetId = ?', whereArgs: [budgetId]);
    // Manual phasing will be deleted due to ON DELETE CASCADE
  }

  /// Insert manual phasing into the database
  /// This should never be called directly, use [insertBudget] instead
  Future<void> insertManualPhasing(ManualPhasing manualPhasing) async {
    final db = await instance.database;
    await db.insert('manual_phasing', manualPhasing.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  /// Get manual phasing from the database
  ///
  /// Returns a list of manual phasing
  Future<List<ManualPhasing>> getManualPhasing(int budgetId) async {
    try {
      final db = await instance.database;
      final manualPhasingRows = await db.query('manual_phasing', where: 'budgetId = ?', whereArgs: [budgetId]);
      return manualPhasingRows.map((row) => ManualPhasing.fromMap(row)).toList();
    } catch(e) {
      LoggingService().info('${DateTime.now()}: DB error, get manual phasing failed with $e');
      debugLog('DB error, get manual phasing failed with $e');
      return [];
    }
  }

  /// Update manual phasing in the database
  Future<void> updateManualPhasing(ManualPhasing manualPhasing) async {
    final db = await instance.database;
    await db.update(
        'manual_phasing', manualPhasing.toMap(), where: 'manualPhasingId = ?',
        whereArgs: [manualPhasing.manualPhasingId]);
  }

  /// Delete manual phasing from the database
  ///
  /// This is not necessary as the cascade should have this covered
  Future<void> deleteManualPhasing(int manualPhasingId) async {
    final db = await instance.database;
    await db.delete('manual_phasing', where: 'manualPhasingId = ?',
        whereArgs: [manualPhasingId]);
  }

  /// Insert actual into the database
  ///
  /// Returns the ID of the inserted actual
  Future<int> insertActual(Actual actual) async {
    try {
      final db = await instance.database;
      final id = await db.insert('actual', {
        'date': actual.date,
        'payeeId': actual.payeeId,
        'categoryId': actual.categoryId,
        'description': actual.description,
        'amount': actual.amount,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
      return id;
    } catch (e) {
      LoggingService().info('${DateTime.now()}: DB error, actual insert failed with $e');
      debugLog('DB error, actual insert failed with $e');
      return 0;
    }
  }

  /// Get actuals from the database
  ///
  /// Returns a list of actuals
  Future<List<Actual>> getActual() async {
    try {
      final db = await instance.database;
      final actualRows = await db.query('actual');
      return actualRows.map((row) => Actual.fromMap(row)).toList();
    } catch(e) {
      LoggingService().info('${DateTime.now()}: DB error, get actuals failed with $e');
      debugLog('DB error, get actuals failed with $e');
      return [];
    }
  }

  /// Update actual in the database
  Future<void> updateActual(Actual actual) async {
    final db = await instance.database;
    await db.update('actual', actual.toMap(), where: 'actualId = ?', whereArgs: [actual.actualId]);
  }

  /// Delete actual from the database
  Future<void> deleteActual(int actualId) async {
    final db = await instance.database;
    await db.delete('actual', where: 'actualId = ?', whereArgs: [actualId]);
  }

  /// Insert category into the database
  Future<void> insertCategory(Category category) async {
    final db = await instance.database;
    await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  /// Get categories from the database
  ///
  /// Returns a list of categories
  Future<List<Category>> getCategories() async {
    try {
      final db = await instance.database;
      final categoryRows = await db.query('categories');
      return categoryRows.map((row) => Category.fromMap(row)).toList();
    } catch(e) {
      LoggingService().info('${DateTime.now()}: DB error, get categories failed with $e');
      debugLog('DB error, get categories failed with $e');
      return [];
    }
  }

  /// Update category in the database
  Future<void> updateCategory(Category category) async {
    final db = await instance.database;
    await db.update('categories', category.toMap(), where: 'categoryId = ?', whereArgs: [category.categoryId]);
  }

  /// Delete category from the database
  Future<void> deleteCategory(int categoryId) async {
    final db = await instance.database;
    await db.delete('categories', where: 'categoryId = ?', whereArgs: [categoryId]);
    // Budgets will be deleted due to ON DELETE CASCADE
  }

  /// Insert payee into the database
  Future<void> insertPayee(Payee payee) async {
    final db = await instance.database;
    await db.insert('payee', payee.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  /// Get payees from the database
  Future<List<Payee>> getPayees() async {
    try {
      final db = await instance.database;
      final payeeRows = await db.query('payee');
      return payeeRows.map((row) => Payee.fromMap(row)).toList();
    } catch(e) {
      LoggingService().info('${DateTime.now()}: DB error, get payees failed with $e');
      debugLog('DB error, get payees failed with $e');
      return [];
    }
  }

  /// Update payee in the database
  Future<void> updatePayee(Payee payee) async {
    final db = await instance.database;
    await db.update('payee', payee.toMap(), where: 'payeeId = ?', whereArgs: [payee.payeeId]);
  }

  /// Delete payee from the database
  Future<void> deletePayee(int payeeId) async {
    final db = await instance.database;
    await db.delete('payee', where: 'payeeId = ?', whereArgs: [payeeId]);
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

}
