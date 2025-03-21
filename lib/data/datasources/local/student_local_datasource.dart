import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/domain/entities/student.dart';
import 'package:sqflite/sqflite.dart';

abstract class StudentLocalDataSource {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<void> saveStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
  Future<List<Student>> getStudentsByClass(String classId);
  Future<void> cacheStudents(List<Student> students);
  Future<List<Student>> getUnsyncedStudents();
  Future<void> markStudentAsSynced(String id);
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final DatabaseHelper dbHelper;

  StudentLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Student>> getAllStudents() async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(
      'students',
    );
    return _convertToStudents(maps);
  }

  @override
  Future<Student?> getStudentById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _convertToStudent(maps.first);
  }

  @override
  Future<void> saveStudent(Student student) async {
    final studentMap = _toMap(student);
    studentMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.insert('students', studentMap);
  }

  @override
  Future<void> updateStudent(Student student) async {
    final studentMap = _toMap(student);
    studentMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.update('students', studentMap, 'id', student.id);
  }

  @override
  Future<void> deleteStudent(String id) async {
    await dbHelper.delete('students', 'id', id);
  }

  @override
  Future<List<Student>> getStudentsByClass(String classId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'class_id = ?',
      whereArgs: [classId],
    );

    return _convertToStudents(maps);
  }

  @override
  Future<void> cacheStudents(List<Student> students) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    for (final student in students) {
      final studentMap = _toMap(student);
      studentMap['is_synced'] = 1; // Mark as synced
      batch.insert(
        'students',
        studentMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Student>> getUnsyncedStudents() async {
    final List<Map<String, dynamic>> maps = await dbHelper.getUnsyncedRecords(
      'students',
    );
    return _convertToStudents(maps);
  }

  @override
  Future<void> markStudentAsSynced(String id) async {
    await dbHelper.markAsSynced('students', id);
  }

  // Helper methods to convert between Student entity and database maps
  List<Student> _convertToStudents(List<Map<String, dynamic>> maps) {
    return maps.map((map) => _convertToStudent(map)).toList();
  }

  Student _convertToStudent(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentNumber: map['student_number'],
      gender: map['gender'],
      classId: map['class_id'],
      className: map['class_name'],
      photoUrl: map['photo_url'],
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      parentId: map['parent_id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> _toMap(Student student) {
    return {
      'id': student.id,
      'name': student.name,
      'student_number': student.studentNumber,
      'gender': student.gender,
      'class_id': student.classId,
      'class_name': student.className,
      'photo_url': student.photoUrl,
      'date_of_birth': student.dateOfBirth.toIso8601String(),
      'parent_id': student.parentId,
      'created_at': student.createdAt.toIso8601String(),
      'updated_at': student.updatedAt.toIso8601String(),
    };
  }
}
