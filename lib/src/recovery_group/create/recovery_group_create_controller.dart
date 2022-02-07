import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Screen { chooseType, inputName, addGuardians }
enum DeviceType { devices, fiduciaries }

class RecoveryGroupCreateController extends ChangeNotifier
    with ReassembleHandler {
  Screen _currentScreen = Screen.chooseType;
  DeviceType? _deviceType;

  @override
  void reassemble() {
    _currentScreen = Screen.chooseType;
    _deviceType = null;
  }

  Screen get currentScreen => _currentScreen;
  DeviceType? get deviceType => _deviceType;

  set currentScreen(value) {
    _currentScreen = value;
    notifyListeners();
  }

  set deviceType(value) {
    _deviceType = value;
    notifyListeners();
  }
}
