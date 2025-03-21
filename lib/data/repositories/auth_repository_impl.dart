import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/datasources/local/auth_local_datasource.dart';
import 'package:insighted/data/datasources/remote/auth_remote_datasource.dart';
import 'package:insighted/domain/entities/user.dart';
import 'package:uuid/uuid.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

abstract class AuthRepository implements SyncableRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  Future<void> createUser(User user, String password);
  Future<void> updateUser(User user);
  Future<List<User>> getUsers();
  Future<List<User>> getUsersByRole(UserRole role);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<User?> signIn(String email, String password) async {
    // Try local authentication first (offline-first approach)
    try {
      final isValidPassword = await localDataSource.verifyPassword(
        email,
        password,
      );
      if (isValidPassword) {
        return await localDataSource.getUserByEmail(email);
      }
    } catch (e) {
      print('AuthRepository: Local authentication error: $e');
    }

    // If local auth fails or user not found locally, try remote if online
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.signIn(email, password);

        if (remoteUser != null) {
          // Cache the user locally for offline access
          await localDataSource.saveUser(remoteUser, password);
          return remoteUser;
        }
      } catch (e) {
        print('AuthRepository: Remote authentication error: $e');
        throw AuthException('Authentication failed: ${e.toString()}');
      }
    }

    // If everything fails, authentication failed
    throw AuthException('Invalid email or password');
  }

  @override
  Future<User?> getUserById(String id) async {
    // Try to get from local source first
    final localUser = await localDataSource.getUserById(id);

    // If online and user not found locally or if we should refresh
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUserById(id);
        if (remoteUser != null) {
          // Note: We don't know the password here, so we can't properly cache
          // the user with a valid password hash. In a real app, you'd need to
          // handle this situation differently, perhaps by updating only
          // non-password fields or requiring password reentry.
          return remoteUser;
        }
      } catch (e) {
        print('AuthRepository: Error getting user from remote: $e');
      }
    }

    return localUser;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    // Try to get from local source first
    final localUser = await localDataSource.getUserByEmail(email);

    // If online and user not found locally or if we should refresh
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUserByEmail(email);
        if (remoteUser != null) {
          // Same password caching issue as getUserById
          return remoteUser;
        }
      } catch (e) {
        print('AuthRepository: Error getting user from remote: $e');
      }
    }

    return localUser;
  }

  @override
  Future<void> createUser(User user, String password) async {
    // Ensure user has ID
    final userWithId =
        user.id.isEmpty
            ? user.copyWith(
              id: const Uuid().v4(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
            : user;

    // Always save locally first
    await localDataSource.saveUser(userWithId, password);

    // Try to save remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createUser(userWithId, password);
      } catch (e) {
        print('AuthRepository: Failed to save user to remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<void> updateUser(User user) async {
    // Ensure updated timestamp
    final userWithTimestamp = user.copyWith(updatedAt: DateTime.now());

    // Always update locally first
    await localDataSource.updateUser(userWithTimestamp);

    // Try to update remotely if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUser(userWithTimestamp);
      } catch (e) {
        print('AuthRepository: Failed to update user to remote: $e');
        // Will be synced later when connection is available
      }
    }
  }

  @override
  Future<List<User>> getUsers() async {
    // Always get data from local source first (offline-first approach)
    final localUsers = await localDataSource.getUsers();

    // If online, try to sync with remote
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getUsers();
        // In a real app, we'd handle the password sync issue here
        return remoteUsers;
      } catch (e) {
        print('AuthRepository: Failed to sync users: $e');
      }
    }

    return localUsers;
  }

  @override
  Future<List<User>> getUsersByRole(UserRole role) async {
    // Always get data from local source first (offline-first approach)
    final localUsers = await localDataSource.getUsersByRole(role);

    // If online, try to sync with remote
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getUsersByRole(role);
        // In a real app, we'd handle the password sync issue here
        return remoteUsers;
      } catch (e) {
        print('AuthRepository: Failed to sync users by role: $e');
      }
    }

    return localUsers;
  }

  @override
  Future<void> syncData() async {
    if (await networkInfo.isConnected) {
      try {
        // This method would handle synchronization of user data
        // between local and remote sources
        print('AuthRepository: Syncing user data');

        // In a real implementation, you would:
        // 1. Get local users that need syncing (marked with is_synced = 0)
        // 2. Push those to remote
        // 3. Get all remote users and update local cache

        // This is simplified for the example
        final remoteUsers = await remoteDataSource.getUsers();
        print(
          'AuthRepository: Retrieved ${remoteUsers.length} users from remote',
        );

        // Note: real implementation would need to handle password hashing properly
      } catch (e) {
        print('AuthRepository: Error syncing user data: $e');
      }
    } else {
      print('AuthRepository: Cannot sync - no internet connection');
    }
  }
}
