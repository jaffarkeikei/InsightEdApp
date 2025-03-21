import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/datasources/local/student_local_datasource.dart';
import 'package:insighted/data/datasources/remote/student_remote_datasource.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<String, dynamic> _dependencies = {};

  T get<T>() {
    return _dependencies[T.toString()] as T;
  }

  void register<T>(T dependency) {
    _dependencies[T.toString()] = dependency;
  }

  void registerLazySingleton<T>(T Function() factoryFunc) {
    if (!_dependencies.containsKey(T.toString())) {
      _dependencies[T.toString()] = factoryFunc();
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

  // Student data sources
  locator.register<StudentLocalDataSource>(
    StudentLocalDataSourceImpl(dbHelper: databaseHelper),
  );

  locator.register<StudentRemoteDataSource>(
    StudentRemoteDataSourceImpl(firestore: firestore),
  );

  // Repositories
  final studentRepository = StudentRepositoryImpl(
    localDataSource: locator.get<StudentLocalDataSource>(),
    remoteDataSource: locator.get<StudentRemoteDataSource>(),
    networkInfo: locator.get<NetworkInfo>(),
  );
  locator.register<StudentRepository>(studentRepository);

  // Sync service (will be expanded as we add more repositories)
  locator.register<SyncService>(
    SyncService(
      networkInfo: locator.get<NetworkInfo>(),
      repositories: [studentRepository],
    ),
  );
}
