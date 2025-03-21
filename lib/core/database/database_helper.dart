import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'insighted.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  // Create the database tables
  Future<void> _createDatabase(Database db, int version) async {
    // Create students table
    await db.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        student_number TEXT NOT NULL,
        gender TEXT NOT NULL,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        photo_url TEXT,
        date_of_birth TEXT NOT NULL,
        parent_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create classes table
    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        grade_level TEXT NOT NULL,
        teacher_id TEXT,
        academic_year TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create teachers table
    await db.execute('''
      CREATE TABLE teachers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        subject_ids TEXT,
        photo_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create subjects table
    await db.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create exams table
    await db.execute('''
      CREATE TABLE exams (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        subject_id TEXT NOT NULL,
        class_id TEXT NOT NULL,
        date TEXT NOT NULL,
        total_marks INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Create results table
    await db.execute('''
      CREATE TABLE results (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        exam_id TEXT NOT NULL,
        marks_obtained REAL NOT NULL,
        comments TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (exam_id) REFERENCES exams (id)
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < newVersion) {
      // Handle schema migrations here
    }
  }

  // Helper methods for raw queries
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String columnId,
    dynamic value,
  ) async {
    final db = await database;
    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [value],
    );
  }

  Future<int> delete(String table, String columnId, dynamic value) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [value]);
  }

  // Methods to mark records for sync
  Future<void> markForSync(String table, String id) async {
    final db = await database;
    await db.update(
      table,
      {'is_synced': 0, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords(String table) async {
    final db = await database;
    return await db.query(table, where: 'is_synced = ?', whereArgs: [0]);
  }

  Future<void> markAsSynced(String table, String id) async {
    final db = await database;
    await db.update(table, {'is_synced': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
