import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        contenido TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertNota(Map<String, dynamic> nota) async {
    final db = await database;
    return await db.insert('notas', nota);
  }

  Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await database;
    return await db.query('notas', orderBy: 'fecha DESC');
  }

  Future<int> updateNota(Map<String, dynamic> nota, int id) async {
    final db = await database;
    return await db.update('notas', nota, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteNota(int id) async {
    final db = await database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
