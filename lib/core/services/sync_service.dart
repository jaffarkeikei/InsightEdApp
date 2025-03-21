import 'dart:async';
import 'package:insighted/core/utils/network_info.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';

class SyncService {
  final NetworkInfo networkInfo;
  final List<StudentRepository> repositories;

  // We'll add more repositories as they're implemented

  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  SyncService({required this.networkInfo, required this.repositories});

  Future<void> synchronizeData() async {
    if (!await networkInfo.isConnected) {
      _syncStatusController.add(
        SyncStatus(
          isSuccessful: false,
          message: 'No internet connection available',
          timestamp: DateTime.now(),
        ),
      );
      throw Exception('No internet connection available for sync');
    }

    _syncStatusController.add(
      SyncStatus(
        isSuccessful: true,
        message: 'Sync started',
        timestamp: DateTime.now(),
        inProgress: true,
      ),
    );

    List<String> errors = [];
    int successCount = 0;

    for (final repository in repositories) {
      try {
        await repository.syncData();
        successCount++;
      } catch (e) {
        errors.add(e.toString());
        print('Repository sync error: $e');
      }
    }

    final isSuccessful = errors.isEmpty;
    final message =
        isSuccessful
            ? 'All data synchronized successfully'
            : 'Some repositories failed to sync: ${errors.length} errors';

    _syncStatusController.add(
      SyncStatus(
        isSuccessful: isSuccessful,
        message: message,
        timestamp: DateTime.now(),
        inProgress: false,
        details: errors.isNotEmpty ? errors.join('\n') : null,
        syncedRepositories: successCount,
        totalRepositories: repositories.length,
      ),
    );
  }

  // Monitor connection status and sync when connection is restored
  void startMonitoring() {
    networkInfo.connectivityStream.listen((status) {
      if (status == ConnectivityStatus.connected) {
        synchronizeData().catchError((e) {
          print('Auto-sync error: $e');
        });
      }
    });
  }

  void dispose() {
    _syncStatusController.close();
  }
}

class SyncStatus {
  final bool isSuccessful;
  final String message;
  final DateTime timestamp;
  final bool inProgress;
  final String? details;
  final int? syncedRepositories;
  final int? totalRepositories;

  SyncStatus({
    required this.isSuccessful,
    required this.message,
    required this.timestamp,
    this.inProgress = false,
    this.details,
    this.syncedRepositories,
    this.totalRepositories,
  });
}
