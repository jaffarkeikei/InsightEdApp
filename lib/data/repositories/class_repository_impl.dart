import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/datasources/local/class_local_datasource.dart';
import 'package:insighted/data/datasources/remote/class_remote_datasource.dart';
import 'package:insighted/domain/entities/class_group.dart';
import 'package:uuid/uuid.dart';

abstract class ClassRepository implements SyncableRepository {
  Future<List<ClassGroup>> getAllClasses();
  Future<ClassGroup?> getClassById(String id);
  Future<void> saveClass(ClassGroup classGroup);
  Future<void> updateClass(ClassGroup classGroup);
  Future<void> deleteClass(String id);
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId);
}

class ClassRepositoryImpl implements ClassRepository {
  final ClassLocalDataSource localDataSource;
  final ClassRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClassRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ClassGroup>> getAllClasses() async {
    // Always get data from local source first (offline-first approach)
    final localClasses = await localDataSource.getAllClasses();

    // If online, try to sync with remote
    if (await networkInfo.isConnected) {
      try {
        final remoteClasses = await remoteDataSource.getAllClasses();
        // Cache the remote data locally
        await localDataSource.cacheClasses(remoteClasses);
        // Return the freshly synced data
        return await localDataSource.getAllClasses();
      } catch (e) {
        // If remote fetch fails, return local data
        print('Failed to sync classes: $e');
      }
    }

    return localClasses;
  }

  @override
  Future<ClassGroup?> getClassById(String id) async {
    // Try to get from local source first
    final localClass = await localDataSource.getClassById(id);

    // If online and class not found locally or if we should refresh
    if (await networkInfo.isConnected) {
      try {
        final remoteClass = await remoteDataSource.getClassById(id);
        if (remoteClass != null) {
          // Cache the remote class locally
          await localDataSource.cacheClasses([remoteClass]);
          return remoteClass;
        }
      } catch (e) {
        print('Failed to get class from remote: $e');
      }
    }

    return localClass;
  }

  @override
  Future<void> saveClass(ClassGroup classGroup) async {
    // Ensure class has ID
    final classWithId =
        classGroup.id.isEmpty
            ? classGroup.copyWith(
              id: const Uuid().v4(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
            : classGroup;

    // Always save locally first
    await localDataSource.saveClass(classWithId);

    // Try to save remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createClass(classWithId);
        // Mark as synced in local DB
        await localDataSource.markClassAsSynced(classWithId.id);
      } catch (e) {
        print('Failed to save class to remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<void> updateClass(ClassGroup classGroup) async {
    // Always update locally first
    final updatedClass = classGroup.copyWith(updatedAt: DateTime.now());
    await localDataSource.updateClass(updatedClass);

    // Try to update remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateClass(updatedClass);
        // Mark as synced in local DB
        await localDataSource.markClassAsSynced(updatedClass.id);
      } catch (e) {
        print('Failed to update class in remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    // Delete locally first
    await localDataSource.deleteClass(id);

    // Try to delete remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteClass(id);
      } catch (e) {
        print('Failed to delete class from remote: $e');
        // Consider tracking deletions for sync later
      }
    }
  }

  @override
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId) async {
    // Get from local source first
    final localClasses = await localDataSource.getClassesByTeacher(teacherId);

    // If online, try to sync
    if (await networkInfo.isConnected) {
      try {
        final remoteClasses = await remoteDataSource.getClassesByTeacher(
          teacherId,
        );
        // Cache the remote classes locally
        await localDataSource.cacheClasses(remoteClasses);
        // Return fresh data
        return await localDataSource.getClassesByTeacher(teacherId);
      } catch (e) {
        print('Failed to sync classes by teacher: $e');
      }
    }

    return localClasses;
  }

  @override
  Future<void> syncData() async {
    if (!await networkInfo.isConnected) {
      throw Exception('No internet connection available for sync');
    }

    // Get all unsynced classes from local DB
    final unsyncedClasses = await localDataSource.getUnsyncedClasses();

    // Sync each class to remote
    for (final classGroup in unsyncedClasses) {
      try {
        // Check if class exists remotely
        final remoteClass = await remoteDataSource.getClassById(classGroup.id);

        if (remoteClass == null) {
          // Create if it doesn't exist
          await remoteDataSource.createClass(classGroup);
        } else {
          // Update if it exists
          await remoteDataSource.updateClass(classGroup);
        }

        // Mark as synced in local DB
        await localDataSource.markClassAsSynced(classGroup.id);
      } catch (e) {
        print('Failed to sync class ${classGroup.id}: $e');
        // Continue with next class
      }
    }

    // Download all remote classes to ensure we have the latest data
    try {
      final remoteClasses = await remoteDataSource.getAllClasses();
      await localDataSource.cacheClasses(remoteClasses);
    } catch (e) {
      print('Failed to download remote classes: $e');
    }
  }
}
