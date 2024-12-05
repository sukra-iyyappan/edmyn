import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Define all connection types
  bool _isMobile = false;
  bool _isWifi = false;
  bool _isEthernet = false;
  bool _isVpn = false;
  bool _isBluetooth = false;
  bool _isOther = false;

  ConnectivityProvider() {
    _checkInitialConnection();
    _monitorConnection();
  }

  // Initial check for connection
  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> connectivityResult =
    await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  // Monitor connectivity changes
  void _monitorConnection() {
    Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Reset the connection flags
    _isMobile = results.contains(ConnectivityResult.mobile);
    _isWifi = results.contains(ConnectivityResult.wifi);
    _isEthernet = results.contains(ConnectivityResult.ethernet);
    _isVpn = results.contains(ConnectivityResult.vpn);
    _isBluetooth = results.contains(ConnectivityResult.bluetooth);
    _isOther = results.contains(ConnectivityResult.other);

    // Determine the overall connection status
    _isConnected = _isMobile ||
        _isWifi ||
        _isEthernet ||
        _isVpn ||
        _isBluetooth ||
        _isOther;

    // Notify listeners of the connection change
    notifyListeners();
  }

  // Optional: Add helper methods to check specific connection types
  bool get isMobile => _isMobile;
  bool get isWifi => _isWifi;
  bool get isEthernet => _isEthernet;
  bool get isVpn => _isVpn;
  bool get isBluetooth => _isBluetooth;
  bool get isOther => _isOther;
}
