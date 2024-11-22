import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Абстрактний клас для бази даних
abstract class DatabaseHelperBase {
  Future<void> insertUser(Map<String, dynamic> user);
  Future<List<Map<String, dynamic>>> getUsers();
  Future<Map<String, dynamic>?> getUserByEmail(String email);
  Future<bool> checkLogin(String email, String password);
  Future<bool> checkIfUserExists(String email);
  Future<void> deleteCharacter(int id);
  Future<void> insertCharacter(Map<String, dynamic> character);
  Future<List<Map<String, dynamic>>> getCharacters();
}

// Реалізація DatabaseHelper
class DatabaseHelper implements DatabaseHelperBase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'user_data.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Таблиця користувачів
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL,
          password TEXT NOT NULL,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL
        )
      ''');
      // Таблиця персонажів
      await db.execute('''
        CREATE TABLE characters (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          class TEXT NOT NULL,
          race TEXT NOT NULL,
          strength INTEGER NOT NULL,
          dexterity INTEGER NOT NULL,
          constitution INTEGER NOT NULL,
          intelligence INTEGER NOT NULL,
          wisdom INTEGER NOT NULL,
          charisma INTEGER NOT NULL
        )
      ''');
    },);
  }

  @override
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: 
    ConflictAlgorithm.replace,);
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs:
     [email],);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<bool> checkLogin(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  @override
  Future<bool> checkIfUserExists(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs:
     [email],);
    return result.isNotEmpty;
  }

  @override
  Future<void> insertCharacter(Map<String, dynamic> character) async {
    final db = await database;
    await db.insert('characters', character, conflictAlgorithm: 
    ConflictAlgorithm.replace,);
  }

  @override
  Future<List<Map<String, dynamic>>> getCharacters() async {
    final db = await database;
    return await db.query('characters');
  }

  @override
  Future<void> deleteCharacter(int id) async {
    final db = await database;
    await db.delete(
      'characters', 
      where: 'id = ?', 
      whereArgs: [id],
    );
  }
  
}
