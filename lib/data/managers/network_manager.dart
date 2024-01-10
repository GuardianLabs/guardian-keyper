import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/data/services/mdns_service.dart';
import 'package:guardian_keyper/data/services/router_service.dart';
import 'package:guardian_keyper/data/services/network_service.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

export 'package:get_it/get_it.dart';

enum NetworkManagerStatus { uninited, stopped, started, pending }

typedef NetworkManagerState = ({
  String deviceName,
  bool hasWiFi,
  bool hasConnectivity,
  bool isBootstrapEnabled,
  NetworkManagerStatus status,
});

/// Depends on [SettingsRepository]
class NetworkManager {
  NetworkManager({
    int? port,
    MdnsService? mdnsService,
    RouterService? routerService,
    NetworkService? networkService,
  })  : _port = port ?? bsPort,
        _mdnsService = mdnsService ?? MdnsService(),
        _routerService = routerService ?? RouterService(),
        _networkService = networkService ?? NetworkService();

  final int _port;
  final MdnsService _mdnsService;
  final RouterService _routerService;
  final NetworkService _networkService;

  final _settingsRepository = GetIt.I<SettingsRepository>();

  final _stateStreamController =
      StreamController<NetworkManagerState>.broadcast();

  late PeerId _selfId;
  late bool _isBootstrapEnabled;

  NetworkManagerStatus _status = NetworkManagerStatus.uninited;

  PeerId get selfId => _selfId;

  bool get isBootstrapEnabled => _isBootstrapEnabled;

  Stream<NetworkManagerState> get state => _stateStreamController.stream;

  Stream<MessageModel> get messageStream => _routerService.messageStream;

  Stream<(PeerId, bool)> get peerStatusChanges =>
      _routerService.peerStatusChanges;

  Future<NetworkManager> init() async {
    if (_status != NetworkManagerStatus.uninited) throw Exception('Init once!');
    _status = NetworkManagerStatus.pending;
    _isBootstrapEnabled =
        _settingsRepository.get<bool>(PreferencesKeys.keyIsBootstrapEnabled) ??
            true;

    final seed = _settingsRepository.get<Uint8List>(PreferencesKeys.keySeed);
    if (seed == null) {
      await _settingsRepository.set<Uint8List>(
        PreferencesKeys.keySeed,
        await _routerService.init(),
      );
    } else {
      await _routerService.init(seed);
    }

    _selfId = PeerId(
      token: _routerService.selfId,
      name: _settingsRepository.get<String>(PreferencesKeys.keyDeviceName) ??
          await _networkService.getDeviceName(),
    );

    _mdnsService.onPeerFound =
        (peerId, address, port) => _routerService.addPeerAddress(
              peerId: peerId,
              address: address,
              port: port ?? _port,
            );

    _networkService.onConnectivityChanged.listen(
      (state) async {
        if (state.hasConnectivity) {
          await stop();
          await start();
        } else {
          await stop();
        }
        _updateState();
      },
    );

    _routerService.toggleBootstrap(isActive: _isBootstrapEnabled);
    _status = NetworkManagerStatus.stopped;
    return this;
  }

  Future<void> close() async {
    await stop();
    await _stateStreamController.close();
  }

  Future<void> start() async {
    if (_status != NetworkManagerStatus.stopped) {
      return;
    } else {
      _status = NetworkManagerStatus.pending;
      await _networkService.checkConnectivity();
    }

    if (_networkService.hasNoConnectivity) {
      _status = NetworkManagerStatus.stopped;
      return;
    } else {
      await _routerService.start(_port);
    }

    if (_networkService.hasWiFi) {
      await _mdnsService.register(_selfId.token, _port);
      await _mdnsService.startDiscovery();
    }
    _status = NetworkManagerStatus.started;
    _updateState();
  }

  Future<void> stop() async {
    if (_status != NetworkManagerStatus.started) return;
    _status = NetworkManagerStatus.pending;
    _routerService.stop();
    await _mdnsService.stopDiscovery();
    await _mdnsService.unregister();
    _status = NetworkManagerStatus.stopped;
    _updateState();
  }

  Future<void> setDeviceName(String value) async {
    if (_selfId.name == value) return;
    if (value.isEmpty) {
      await _settingsRepository.delete(PreferencesKeys.keyDeviceName);
      _selfId = _selfId.copyWith(
        name: await _networkService.getDeviceName(),
      );
    } else {
      _selfId = _selfId.copyWith(name: value);
      await _settingsRepository.set<String>(
        PreferencesKeys.keyDeviceName,
        value,
      );
    }
    _updateState();
  }

  Future<void> setIsBootstrapEnabled(bool isEnabled) async {
    if (_isBootstrapEnabled == isEnabled) return;
    _isBootstrapEnabled = isEnabled;
    await _settingsRepository.set<bool>(
      PreferencesKeys.keyIsBootstrapEnabled,
      isEnabled,
    );
    _routerService.toggleBootstrap(isActive: isEnabled);
    _updateState();
  }

  Future<bool> pingPeer(PeerId peerId) => _routerService.pingPeer(peerId);

  bool getPeerStatus(PeerId peerId) => _routerService.getPeerStatus(peerId);

  Future<void> sendToPeer(
    PeerId peerId, {
    required MessageModel message,
    bool isConfirmable = false,
  }) =>
      _routerService.sendToPeer(
        peerId,
        message: message,
        isConfirmable: isConfirmable,
      );

  void _updateState() => _stateStreamController.add((
        status: _status,
        deviceName: _selfId.name,
        hasWiFi: _networkService.hasWiFi,
        isBootstrapEnabled: _isBootstrapEnabled,
        hasConnectivity: _networkService.hasConnectivity,
      ));
}
