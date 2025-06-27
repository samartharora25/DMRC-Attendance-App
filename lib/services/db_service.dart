import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/user.dart';

class DBService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, 'dmrc.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            empId TEXT,
            faceImagePath TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE login_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            empId TEXT,
            timestamp TEXT,
            faceImagePath TEXT
          )
        ''');
      },
    );
  }

  // Insert new user
  static Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Get all users
  static Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Log login
  static Future<int> logLogin(User user, String timestamp) async {
    final db = await database;
    return await db.insert('login_logs', {
      'name': user.name,
      'empId': user.empId,
      'timestamp': timestamp,
      'faceImagePath': user.faceImagePath
    });
  }
}
  