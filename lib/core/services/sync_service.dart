import 'dart:async';
import 'package:insighted/core/utils/network_info.dart';

// Define a common interface for repositories that can be synced
abstract class SyncableRepository {
  Future<void> syncData();
}

class SyncService {
  final NetworkInfo networkInfo;
  final List<SyncableRepository> repositories;

  // We'll add more repositories as they're implemented

  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  // Timer for periodic sync
  Timer? _periodicSyncTimer;
  static const Duration _syncInterval = Duration(minutes: 15);

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  SyncService({required this.networkInfo, required this.repositories});

  Future<void> synchronizeData() async {
    print('SyncService: Starting data synchronization');
    try {
      bool isConnected = false;
      try {
        isConnected = await networkInfo.isConnected;
      } catch (e) {
        print('SyncService: Error checking connectivity: $e');
        isConnected = false;
      }

      if (!isConnected) {
        print('SyncService: No internet connection available');
        _syncStatusController.add(
          SyncStatus(
            isSuccessful: false,
            message: 'No internet connection available',
            timestamp: DateTime.now(),
          ),
        );
        return; // Return instead of throwing (offline-first approach)
      }

      print('SyncService: Internet connection available, starting sync');
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

      // Safety check for empty repositories list
      if (repositories.isEmpty) {
        print('SyncService: No repositories to sync');
        _syncStatusController.add(
          SyncStatus(
            isSuccessful: true,
            message: 'No repositories to sync',
            timestamp: DateTime.now(),
            inProgress: false,
            syncedRepositories: 0,
            totalRepositories: 0,
          ),
        );
        return;
      }

      print('SyncService: Syncing ${repositories.length} repositories');
      for (final repository in repositories) {
        try {
          await repository.syncData();
          successCount++;
          print(
            'SyncService: Repository sync successful (${successCount}/${repositories.length})',
          );
        } catch (e) {
          errors.add(e.toString());
          print('SyncService: Repository sync error: $e');
        }
      }

      final isSuccessful = errors.isEmpty;
      final message =
          isSuccessful
              ? 'All data synchronized successfully'
              : 'Some repositories failed to sync: ${errors.length} errors';

      print('SyncService: Sync complete - $message');
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
    } catch (e) {
      print('SyncService: Unexpected error during sync: $e');
      _syncStatusController.add(
        SyncStatus(
          isSuccessful: false,
          message: 'Sync failed due to unexpected error: $e',
          timestamp: DateTime.now(),
          inProgress: false,
        ),
      );
    }
  }

  // Monitor connection status and sync when connection is restored
  void startMonitoring() {
    print('SyncService: Starting connectivity monitoring');
    try {
      networkInfo.connectivityStream.listen(
        (status) {
          print('SyncService: Connectivity changed to: $status');
          if (status == ConnectivityStatus.connected) {
            print('SyncService: Connected - triggering sync');
            synchronizeData().catchError((e) {
              print('SyncService: Auto-sync error: $e');
            });
          }
        },
        onError: (e) {
          print('SyncService: Error in connectivity listener: $e');
        },
      );
      print('SyncService: Connectivity monitoring started successfully');

      // Set up periodic sync
      _startPeriodicSync();
    } catch (e) {
      print('SyncService: Failed to start connectivity monitoring: $e');
    }
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel(); // Cancel existing timer if any

    print(
      'SyncService: Setting up periodic sync every ${_syncInterval.inMinutes} minutes',
    );
    _periodicSyncTimer = Timer.periodic(_syncInterval, (_) {
      print('SyncService: Running periodic sync');
      synchronizeData().catchError((e) {
        print('SyncService: Periodic sync error: $e');
      });
    });
  }

  void dispose() {
    print('SyncService: Disposing sync status controller');
    _periodicSyncTimer?.cancel();
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
