import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final _initializationTimeout = const Duration(seconds: 10);
  final _completer = Completer<Database>();
  bool _isInitializing = false;

  Future<Database> get database async {
    if (_database != null) {
      print('DatabaseHelper: Returning existing database instance');
      return _database!;
    }

    // Check if initialization is already in progress
    if (_isInitializing) {
      print('DatabaseHelper: Waiting for ongoing initialization');
      return _completer.future;
    }

    // Start initialization with timeout
    _isInitializing = true;
    print('DatabaseHelper: Starting database initialization');

    try {
      // Set up a timeout
      final timeoutFuture = Future.delayed(_initializationTimeout, () {
        if (!_completer.isCompleted) {
          print(
            'DatabaseHelper: Initialization timed out after ${_initializationTimeout.inSeconds} seconds',
          );
          _completer.completeError(
            TimeoutException(
              'Database initialization timed out',
              _initializationTimeout,
            ),
          );
        }
      });

      // Start actual initialization
      _database = await _initDatabase();
      print('DatabaseHelper: Database initialized successfully');

      if (!_completer.isCompleted) {
        _completer.complete(_database);
      }

      return _database!;
    } catch (e) {
      print('DatabaseHelper: Error initializing database: $e');
      if (!_completer.isCompleted) {
        _completer.completeError(e);
      }
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      print('DatabaseHelper: Getting application documents directory');
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'insighted.db');
      print('DatabaseHelper: Database path: $path');

      // Check if database file exists
      final dbFile = File(path);
      final exists = await dbFile.exists();
      print(
        'DatabaseHelper: Database file ${exists ? 'exists' : 'does not exist'}',
      );

      print('DatabaseHelper: Opening database');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print('DatabaseHelper: Creating database tables (version $version)');
          await _createDatabase(db, version);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print(
            'DatabaseHelper: Upgrading database from v$oldVersion to v$newVersion',
          );
          await _upgradeDatabase(db, oldVersion, newVersion);
        },
        onOpen: (db) {
          print('DatabaseHelper: Database opened successfully');
        },
      );
    } catch (e) {
      print('DatabaseHelper: Error in _initDatabase(): $e');
      rethrow;
    }
  }

  // Create the database tables
  Future<void> _createDatabase(Database db, int version) async {
    try {
      // Create students table
      print('DatabaseHelper: Creating students table');
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
      print('DatabaseHelper: Creating classes table');
      await db.execute('''
        CREATE TABLE classes (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          grade TEXT NOT NULL,
          teacher_id TEXT,
          teacher_name TEXT,
          academic_year TEXT NOT NULL,
          term TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_synced INTEGER DEFAULT 0
        )
      ''');

      // Create teachers table
      print('DatabaseHelper: Creating teachers table');
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
      print('DatabaseHelper: Creating subjects table');
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
      print('DatabaseHelper: Creating exams table');
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
      print('DatabaseHelper: Creating results table');
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

      // Create users table
      print('DatabaseHelper: Creating users table');
      await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          phone_number TEXT,
          role TEXT NOT NULL,
          school_id TEXT,
          school_name TEXT,
          is_active INTEGER NOT NULL DEFAULT 1,
          photo_url TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_synced INTEGER DEFAULT 0
        )
      ''');

      print('DatabaseHelper: All tables created successfully');
    } catch (e) {
      print('DatabaseHelper: Error creating database tables: $e');
      rethrow;
    }
  }

  // Handle database upgrades
  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    print('DatabaseHelper: Database upgrade not implemented yet');
    // Will be implemented as needed in the future
  }

  // Helper methods for raw queries with error handling
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    try {
      print('DatabaseHelper: Querying all rows from table: $table');
      final db = await database;
      final results = await db.query(table);
      print('DatabaseHelper: Retrieved ${results.length} rows from $table');
      return results;
    } catch (e) {
      print('DatabaseHelper: Error querying rows from $table: $e');
      return [];
    }
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    try {
      print('DatabaseHelper: Inserting into table: $table');
      final db = await database;
      final result = await db.insert(
        table,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('DatabaseHelper: Insert succeeded with id: $result');
      return result;
    } catch (e) {
      print('DatabaseHelper: Error inserting into $table: $e');
      return -1;
    }
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String columnId,
    dynamic value,
  ) async {
    try {
      print('DatabaseHelper: Updating table: $table where $columnId = $value');
      final db = await database;
      final result = await db.update(
        table,
        row,
        where: '$columnId = ?',
        whereArgs: [value],
      );
      print('DatabaseHelper: Updated $result row(s)');
      return result;
    } catch (e) {
      print('DatabaseHelper: Error updating $table: $e');
      return 0;
    }
  }

  Future<int> delete(String table, String columnId, dynamic value) async {
    try {
      print(
        'DatabaseHelper: Deleting from table: $table where $columnId = $value',
      );
      final db = await database;
      final result = await db.delete(
        table,
        where: '$columnId = ?',
        whereArgs: [value],
      );
      print('DatabaseHelper: Deleted $result row(s)');
      return result;
    } catch (e) {
      print('DatabaseHelper: Error deleting from $table: $e');
      return 0;
    }
  }

  // Methods to mark records for sync
  Future<void> markForSync(String table, String id) async {
    try {
      print(
        'DatabaseHelper: Marking record for sync in table: $table, id: $id',
      );
      final db = await database;
      await db.update(
        table,
        {'is_synced': 0, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('DatabaseHelper: Error marking record for sync in $table: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords(String table) async {
    try {
      print('DatabaseHelper: Getting unsynced records from table: $table');
      final db = await database;
      final results = await db.query(
        table,
        where: 'is_synced = ?',
        whereArgs: [0],
      );
      print(
        'DatabaseHelper: Retrieved ${results.length} unsynced records from $table',
      );
      return results;
    } catch (e) {
      print('DatabaseHelper: Error getting unsynced records from $table: $e');
      return [];
    }
  }

  Future<void> markAsSynced(String table, String id) async {
    try {
      print(
        'DatabaseHelper: Marking record as synced in table: $table, id: $id',
      );
      final db = await database;
      await db.update(
        table,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('DatabaseHelper: Error marking record as synced in $table: $e');
    }
  }

  // Method to properly close the database
  Future<void> close() async {
    if (_database != null) {
      print('DatabaseHelper: Closing database');
      await _database!.close();
      _database = null;
      print('DatabaseHelper: Database closed successfully');
    }
  }
}
