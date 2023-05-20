import 'dart:math';

import 'package:punch_clock/punchClockModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'punchClock.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS ${PunchClock.TABLE_NAME} (
        ${PunchClock.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PunchClock.FIELD_LATITUDE} TEXT NOT NULL,
        ${PunchClock.FIELD_LONGITUDE} TEXT NOT NULL,
        ${PunchClock.FIELD_DATE} TEXT NOT NULL);
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
