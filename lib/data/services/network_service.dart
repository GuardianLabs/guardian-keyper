import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef ConnectivityState = ({bool hasConnectivity, bool hasWiFi});

class NetworkService {
  static final _connectivity = Connectivity();

  bool get hasWiFi => _connectivityType == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityType != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityType == ConnectivityResult.none;

  Stream<ConnectivityState> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map<ConnectivityState>((type) {
        _connectivityType = type.first;
        return (
          hasConnectivity: _connectivityType != ConnectivityResult.none,
          hasWiFi: _connectivityType == ConnectivityResult.wifi,
        );
      });

  ConnectivityResult _connectivityType = ConnectivityResult.none;

  Future<bool> checkConnectivity() async {
    _connectivityType = (await _connectivity.checkConnectivity()).first;
    return hasConnectivity;
  }

  Future<String> getDeviceName([String undefinedName = 'Undefined']) async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).model;
    }
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).model;
    }
    return undefinedName;
  }
}
