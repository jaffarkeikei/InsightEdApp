import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { connected, disconnected }

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityStatus> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();
  bool _isInitialized = false;
  StreamSubscription? _connectivitySubscription;

  NetworkInfoImpl({required this.connectivity}) {
    _initialize();
  }

  void _initialize() {
    if (_isInitialized) return;

    print('NetworkInfo: Initializing connectivity monitoring');
    try {
      // Set up stream transformer
      _connectivitySubscription = connectivity.onConnectivityChanged
          .handleError((error) {
            print('NetworkInfo: Error in connectivity stream: $error');
            return ConnectivityResult.none;
          })
          .map(_mapConnectivityResult)
          .listen(
            (status) {
              print('NetworkInfo: Connectivity changed to: $status');
              _controller.add(status);
            },
            onError: (e) {
              print('NetworkInfo: Error in connectivity listener: $e');
              _controller.add(ConnectivityStatus.disconnected);
            },
          );

      // Check initial connectivity
      _checkConnectivity();

      _isInitialized = true;
      print('NetworkInfo: Connectivity monitoring initialized');
    } catch (e) {
      print('NetworkInfo: Failed to initialize connectivity monitoring: $e');
      _controller.add(ConnectivityStatus.disconnected);
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await connectivity.checkConnectivity();
      final status = _mapConnectivityResult(result);
      print('NetworkInfo: Initial connectivity status: $status');
      _controller.add(status);
    } catch (e) {
      print('NetworkInfo: Error checking initial connectivity: $e');
      _controller.add(ConnectivityStatus.disconnected);
    }
  }

  ConnectivityStatus _mapConnectivityResult(ConnectivityResult result) {
    return result != ConnectivityResult.none
        ? ConnectivityStatus.connected
        : ConnectivityStatus.disconnected;
  }

  @override
  Future<bool> get isConnected async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      print('NetworkInfo: Connectivity check result: $connectivityResult');
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('NetworkInfo: Error checking connectivity: $e');
      // Assume disconnected on error
      return false;
    }
  }

  @override
  Stream<ConnectivityStatus> get connectivityStream {
    if (!_isInitialized) {
      _initialize();
    }
    return _controller.stream;
  }

  void dispose() {
    print('NetworkInfo: Disposing connectivity resources');
    _connectivitySubscription?.cancel();
    _controller.close();
  }
}
