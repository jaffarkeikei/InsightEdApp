import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { connected, disconnected }

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityStatus> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityStatus> get connectivityStream {
    return connectivity.onConnectivityChanged.map((status) {
      return status != ConnectivityResult.none
          ? ConnectivityStatus.connected
          : ConnectivityStatus.disconnected;
    });
  }
}
