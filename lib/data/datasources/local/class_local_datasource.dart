import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/domain/entities/class_group.dart';
import 'package:sqflite/sqflite.dart';

abstract class ClassLocalDataSource {
  Future<List<ClassGroup>> getAllClasses();
  Future<ClassGroup?> getClassById(String id);
  Future<void> saveClass(ClassGroup classGroup);
  Future<void> updateClass(ClassGroup classGroup);
  Future<void> deleteClass(String id);
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId);
  Future<void> cacheClasses(List<ClassGroup> classes);
  Future<List<ClassGroup>> getUnsyncedClasses();
  Future<void> markClassAsSynced(String id);
}

class ClassLocalDataSourceImpl implements ClassLocalDataSource {
  final DatabaseHelper dbHelper;

  ClassLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<ClassGroup>> getAllClasses() async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(
      'classes',
    );
    return _convertToClasses(maps);
  }

  @override
  Future<ClassGroup?> getClassById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'classes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _convertToClass(maps.first);
  }

  @override
  Future<void> saveClass(ClassGroup classGroup) async {
    final classMap = _toMap(classGroup);
    classMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.insert('classes', classMap);
  }

  @override
  Future<void> updateClass(ClassGroup classGroup) async {
    final classMap = _toMap(classGroup);
    classMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.update('classes', classMap, 'id', classGroup.id);
  }

  @override
  Future<void> deleteClass(String id) async {
    await dbHelper.delete('classes', 'id', id);
  }

  @override
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'classes',
      where: 'teacher_id = ?',
      whereArgs: [teacherId],
    );

    return _convertToClasses(maps);
  }

  @override
  Future<void> cacheClasses(List<ClassGroup> classes) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    for (final classGroup in classes) {
      final classMap = _toMap(classGroup);
      classMap['is_synced'] = 1; // Mark as synced
      batch.insert(
        'classes',
        classMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<ClassGroup>> getUnsyncedClasses() async {
    final List<Map<String, dynamic>> maps = await dbHelper.getUnsyncedRecords(
      'classes',
    );
    return _convertToClasses(maps);
  }

  @override
  Future<void> markClassAsSynced(String id) async {
    await dbHelper.markAsSynced('classes', id);
  }

  // Helper methods to convert between ClassGroup entity and database maps
  List<ClassGroup> _convertToClasses(List<Map<String, dynamic>> maps) {
    return maps.map((map) => _convertToClass(map)).toList();
  }

  ClassGroup _convertToClass(Map<String, dynamic> map) {
    return ClassGroup(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      grade: map['grade'],
      teacherId: map['teacher_id'],
      teacherName: map['teacher_name'],
      academicYear: int.parse(map['academic_year']),
      term: int.parse(map['term'] ?? '1'), // Default to term 1 if missing
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> _toMap(ClassGroup classGroup) {
    return {
      'id': classGroup.id,
      'name': classGroup.name,
      'description': classGroup.description,
      'grade': classGroup.grade,
      'teacher_id': classGroup.teacherId,
      'teacher_name': classGroup.teacherName,
      'academic_year': classGroup.academicYear.toString(),
      'term': classGroup.term.toString(),
      'created_at': classGroup.createdAt.toIso8601String(),
      'updated_at': classGroup.updatedAt.toIso8601String(),
    };
  }
}
