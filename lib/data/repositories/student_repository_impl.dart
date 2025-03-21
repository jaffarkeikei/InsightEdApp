import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/datasources/local/student_local_datasource.dart';
import 'package:insighted/data/datasources/remote/student_remote_datasource.dart';
import 'package:insighted/domain/entities/student.dart';
import 'package:uuid/uuid.dart';

abstract class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<void> saveStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
  Future<List<Student>> getStudentsByClass(String classId);
  Future<void> syncData();
}

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;
  final StudentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StudentRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Student>> getAllStudents() async {
    // Always get data from local source first (offline-first approach)
    final localStudents = await localDataSource.getAllStudents();

    // If online, try to sync with remote
    if (await networkInfo.isConnected) {
      try {
        final remoteStudents = await remoteDataSource.getAllStudents();
        // Cache the remote data locally
        await localDataSource.cacheStudents(remoteStudents);
        // Return the freshly synced data
        return await localDataSource.getAllStudents();
      } catch (e) {
        // If remote fetch fails, return local data
        print('Failed to sync students: $e');
      }
    }

    return localStudents;
  }

  @override
  Future<Student?> getStudentById(String id) async {
    // Try to get from local source first
    final localStudent = await localDataSource.getStudentById(id);

    // If online and student not found locally or if we should refresh
    if (await networkInfo.isConnected) {
      try {
        final remoteStudent = await remoteDataSource.getStudentById(id);
        if (remoteStudent != null) {
          // Cache the remote student locally
          await localDataSource.cacheStudents([remoteStudent]);
          return remoteStudent;
        }
      } catch (e) {
        print('Failed to get student from remote: $e');
      }
    }

    return localStudent;
  }

  @override
  Future<void> saveStudent(Student student) async {
    // Ensure student has ID
    final studentWithId =
        student.id.isEmpty
            ? student.copyWith(
              id: const Uuid().v4(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
            : student;

    // Always save locally first
    await localDataSource.saveStudent(studentWithId);

    // Try to save remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createStudent(studentWithId);
        // Mark as synced in local DB
        await localDataSource.markStudentAsSynced(studentWithId.id);
      } catch (e) {
        print('Failed to save student to remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    // Always update locally first
    final updatedStudent = student.copyWith(updatedAt: DateTime.now());
    await localDataSource.updateStudent(updatedStudent);

    // Try to update remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateStudent(updatedStudent);
        // Mark as synced in local DB
        await localDataSource.markStudentAsSynced(updatedStudent.id);
      } catch (e) {
        print('Failed to update student in remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    // Delete locally first
    await localDataSource.deleteStudent(id);

    // Try to delete remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteStudent(id);
      } catch (e) {
        print('Failed to delete student from remote: $e');
        // Consider tracking deletions for sync later
      }
    }
  }

  @override
  Future<List<Student>> getStudentsByClass(String classId) async {
    // Get from local source first
    final localStudents = await localDataSource.getStudentsByClass(classId);

    // If online, try to sync
    if (await networkInfo.isConnected) {
      try {
        final remoteStudents = await remoteDataSource.getStudentsByClass(
          classId,
        );
        // Cache the remote students locally
        await localDataSource.cacheStudents(remoteStudents);
        // Return fresh data
        return await localDataSource.getStudentsByClass(classId);
      } catch (e) {
        print('Failed to sync students by class: $e');
      }
    }

    return localStudents;
  }

  @override
  Future<void> syncData() async {
    if (!await networkInfo.isConnected) {
      throw Exception('No internet connection available for sync');
    }

    // Get all unsynced students from local DB
    final unsyncedStudents = await localDataSource.getUnsyncedStudents();

    // Sync each student to remote
    for (final student in unsyncedStudents) {
      try {
        // Check if student exists remotely
        final remoteStudent = await remoteDataSource.getStudentById(student.id);

        if (remoteStudent == null) {
          // Create if it doesn't exist
          await remoteDataSource.createStudent(student);
        } else {
          // Update if it exists
          await remoteDataSource.updateStudent(student);
        }

        // Mark as synced in local DB
        await localDataSource.markStudentAsSynced(student.id);
      } catch (e) {
        print('Failed to sync student ${student.id}: $e');
        // Continue with next student
      }
    }

    // Download all remote students to ensure we have the latest data
    try {
      final remoteStudents = await remoteDataSource.getAllStudents();
      await localDataSource.cacheStudents(remoteStudents);
    } catch (e) {
      print('Failed to download remote students: $e');
    }
  }
}
