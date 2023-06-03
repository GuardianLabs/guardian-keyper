import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef ConnectivityState = ({bool hasConnectivity, bool hasWiFi});

class NetworkService {
  static final _connectivity = Connectivity();

  late final onConnectivityChanged =
      _connectivity.onConnectivityChanged.map<ConnectivityState>((type) {
    _connectivityType = type;
    return (
      hasConnectivity: type != ConnectivityResult.none,
      hasWiFi: type == ConnectivityResult.wifi,
    );
  });

  bool get hasWiFi => _connectivityType == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityType != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityType == ConnectivityResult.none;

  ConnectivityResult _connectivityType = ConnectivityResult.none;

  Future<bool> checkConnectivity() async {
    _connectivityType = await _connectivity.checkConnectivity();
    return hasConnectivity;
  }

  Future<String> getDeviceName([String undefinedName = 'Undefined']) async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).model;
    }
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).model ?? undefinedName;
    }
    return undefinedName;
  }
}
