// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      value INTEGER NOT NULL
    )
    ''');
  }

  Future<void> insertOrUpdateUser(String username, int value) async {
    final db = await instance.database;

    final result =
        await db.query('users', where: 'username = ?', whereArgs: [username]);

    if (result.isEmpty) {
      await db.insert('users', {'username': username, 'value': value});
    } else {
      await db.update('users', {'value': value},
          where: 'username = ?', whereArgs: [username]);
    }
  }

  Future<int?> getUserValue(String username) async {
    final db = await instance.database;
    final result =
        await db.query('users', where: 'username = ?', whereArgs: [username]);

    if (result.isNotEmpty) {
      return result.first['value'] as int?;
    }
    return null;
  }
}
