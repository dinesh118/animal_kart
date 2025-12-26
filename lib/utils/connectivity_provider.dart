import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { connected, disconnected }

final connectivityProvider = StreamProvider<ConnectionStatus>((ref) async* {
  final connectivity = Connectivity();

  // Emit initial state
  final initialResult = await connectivity.checkConnectivity();
  yield initialResult.contains(ConnectivityResult.none) || initialResult.isEmpty
      ? ConnectionStatus.disconnected
      : ConnectionStatus.connected;

  // Listen for changes
  await for (final result in connectivity.onConnectivityChanged) {
    yield result.contains(ConnectivityResult.none) || result.isEmpty
        ? ConnectionStatus.disconnected
        : ConnectionStatus.connected;
  }
});
