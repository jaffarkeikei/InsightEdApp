import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/datasources/local/auth_local_datasource.dart';
import 'package:insighted/data/datasources/local/class_local_datasource.dart';
import 'package:insighted/data/datasources/local/student_local_datasource.dart';
import 'package:insighted/data/datasources/remote/auth_remote_datasource.dart';
import 'package:insighted/data/datasources/remote/class_remote_datasource.dart';
import 'package:insighted/data/datasources/remote/student_remote_datasource.dart';
import 'package:insighted/data/repositories/auth_repository_impl.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';
import 'package:insighted/presentation/providers/auth_provider.dart';

/// A simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<String, dynamic> _dependencies = {};
  bool _isInitialized = false;

  /// Get a registered dependency
  T get<T>() {
    final key = T.toString();
    if (!_dependencies.containsKey(key)) {
      print('ServiceLocator: Dependency not found: $key');
      throw Exception('Dependency not found: $key');
    }
    return _dependencies[key] as T;
  }

  /// Register a dependency
  void register<T>(T dependency) {
    final key = T.toString();
    print('ServiceLocator: Registering $key');
    _dependencies[key] = dependency;
  }

  /// Register a singleton that is lazily initialized
  void registerLazySingleton<T>(T Function() factoryFunc) {
    final key = T.toString();
    if (!_dependencies.containsKey(key)) {
      print('ServiceLocator: Registering lazy singleton: $key');
      try {
        final instance = factoryFunc();
        _dependencies[key] = instance;
        print('ServiceLocator: Lazy singleton initialized: $key');
      } catch (e) {
        print('ServiceLocator: Error initializing lazy singleton $key: $e');
        rethrow;
      }
    }
  }

  /// Check if a dependency is registered
  bool isRegistered<T>() {
    return _dependencies.containsKey(T.toString());
  }

  /// Initialize core services
  void initializeCore() {
    if (_isInitialized) {
      print('ServiceLocator: Core services already initialized');
      return;
    }

    print('ServiceLocator: Initializing core services');

    try {
      // Register database helper
      if (!isRegistered<DatabaseHelper>()) {
        final dbHelper = DatabaseHelper();
        register<DatabaseHelper>(dbHelper);
      }

      // Register connectivity and network info
      if (!isRegistered<Connectivity>()) {
        final connectivity = Connectivity();
        register<Connectivity>(connectivity);
      }

      if (!isRegistered<NetworkInfo>()) {
        final networkInfo = NetworkInfoImpl(connectivity: get<Connectivity>());
        register<NetworkInfo>(networkInfo);
      }

      _isInitialized = true;
      print('ServiceLocator: Core services initialized successfully');
    } catch (e) {
      print('ServiceLocator: Error initializing core services: $e');
      _isInitialized = false;
    }
  }
}

Future<void> setupDependencies() async {
  final locator = ServiceLocator();

  // Core services
  final databaseHelper = DatabaseHelper();
  locator.register<DatabaseHelper>(databaseHelper);

  // Network info
  final connectivity = Connectivity();
  locator.register<NetworkInfo>(NetworkInfoImpl(connectivity: connectivity));

  // Firebase
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // Auth data sources
  locator.register<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(dbHelper: databaseHelper),
  );

  locator.register<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(firestore: firestore, firebaseAuth: firebaseAuth),
  );

  // Student data sources
  locator.register<StudentLocalDataSource>(
    StudentLocalDataSourceImpl(dbHelper: databaseHelper),
  );

  locator.register<StudentRemoteDataSource>(
    StudentRemoteDataSourceImpl(firestore: firestore),
  );

  // Class data sources
  locator.register<ClassLocalDataSource>(
    ClassLocalDataSourceImpl(dbHelper: databaseHelper),
  );

  locator.register<ClassRemoteDataSource>(
    ClassRemoteDataSourceImpl(firestore: firestore),
  );

  // Repositories
  final authRepository = AuthRepositoryImpl(
    localDataSource: locator.get<AuthLocalDataSource>(),
    remoteDataSource: locator.get<AuthRemoteDataSource>(),
    networkInfo: locator.get<NetworkInfo>(),
  );
  locator.register<AuthRepository>(authRepository);

  final studentRepository = StudentRepositoryImpl(
    localDataSource: locator.get<StudentLocalDataSource>(),
    remoteDataSource: locator.get<StudentRemoteDataSource>(),
    networkInfo: locator.get<NetworkInfo>(),
  );
  locator.register<StudentRepository>(studentRepository);

  final classRepository = ClassRepositoryImpl(
    localDataSource: locator.get<ClassLocalDataSource>(),
    remoteDataSource: locator.get<ClassRemoteDataSource>(),
    networkInfo: locator.get<NetworkInfo>(),
  );
  locator.register<ClassRepository>(classRepository);

  // Providers
  locator.register<AuthProvider>(AuthProvider(repository: authRepository));

  // Sync service
  locator.register<SyncService>(
    SyncService(
      networkInfo: locator.get<NetworkInfo>(),
      repositories: [studentRepository, classRepository, authRepository],
    ),
  );
}
