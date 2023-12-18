import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

import 'network_service.dart';
import 'mdns_service.dart';
import 'router_service.dart';

enum NetworkManagerStatus { uninited, stopped, started, pending }

typedef NetworkManagerState = ({
  PeerId peerId,
  bool hasWiFi,
  bool hasConnectivity,
  bool isBootstrapEnabled,
  NetworkManagerStatus status,
});

/// Depends on [PreferencesService]
class NetworkManager {
  NetworkManager({
    MdnsService? mdnsService,
    RouterService? routerService,
    NetworkService? networkService,
  })  : _mdnsService = mdnsService ?? MdnsService(),
        _routerService = routerService ?? RouterService(),
        _networkService = networkService ?? NetworkService();

  // Public fields
  late final pingPeer = _routerService.pingPeer;
  late final sendToPeer = _routerService.sendToPeer;
  late final getPeerStatus = _routerService.getPeerStatus;
  late final toggleBootstrap = _routerService.toggleBootstrap;
  late final discoverNeighbours = _mdnsService.startDiscovery;
  late final peerStatusChanges = _routerService.peerStatusChanges;
  late final messageStream = _routerService.messageStream;

  // Private fields
  final MdnsService _mdnsService;
  final RouterService _routerService;
  final NetworkService _networkService;

  final _preferencesService = GetIt.I<PreferencesService>();

  final _stateStreamController =
      StreamController<NetworkManagerState>.broadcast();

  late PeerId _selfId;
  late bool _isBootstrapEnabled;

  int port = defaultPort;

  NetworkManagerStatus _status = NetworkManagerStatus.uninited;

  // Public methods
  PeerId get selfId => _selfId;

  bool get isBootstrapEnabled => _isBootstrapEnabled;

  Stream<NetworkManagerState> get state => _stateStreamController.stream;

  Future<NetworkManager> init() async {
    if (_status != NetworkManagerStatus.uninited) throw Exception('Init once!');
    _status = NetworkManagerStatus.pending;
    _isBootstrapEnabled = await _preferencesService
            .get<bool>(PreferencesKeys.keyIsBootstrapEnabled) ??
        true;

    final seed =
        await _preferencesService.get<Uint8List>(PreferencesKeys.keySeed);
    if (seed == null) {
      await _preferencesService.set<Uint8List>(
        PreferencesKeys.keySeed,
        await _routerService.init(),
      );
    } else {
      await _routerService.init(seed);
    }

    _selfId = PeerId(
      token: _routerService.selfId,
      name: await _preferencesService
              .get<String>(PreferencesKeys.keyDeviceName) ??
          await _networkService.getDeviceName(),
    );

    _mdnsService.onPeerFound =
        (peerId, address, port) => _routerService.addPeerAddress(
              peerId: peerId,
              address: address,
              port: port ?? this.port,
            );

    _networkService.onConnectivityChanged.listen((state) async {
      if (state.hasConnectivity) {
        await stop();
        await start();
      } else {
        await stop();
      }
      _updateState();
    });

    toggleBootstrap(isActive: _isBootstrapEnabled);
    _status = NetworkManagerStatus.stopped;
    return this;
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
      await _routerService.start(port);
    }

    if (_networkService.hasWiFi) {
      await _mdnsService.register(_selfId.token, port);
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
    _selfId = _selfId.copyWith(name: value);
    await _preferencesService.set<String>(
      PreferencesKeys.keyDeviceName,
      value,
    );
    _updateState();
  }

  Future<void> setBootstrap({required bool isEnabled}) async {
    _isBootstrapEnabled = isEnabled;
    await _preferencesService.set<bool>(
      PreferencesKeys.keyIsBootstrapEnabled,
      isEnabled,
    );
    _updateState();
  }

  void _updateState() => _stateStreamController.add((
        status: _status,
        peerId: _selfId,
        hasWiFi: _networkService.hasWiFi,
        isBootstrapEnabled: _isBootstrapEnabled,
        hasConnectivity: _networkService.hasConnectivity,
      ));
}
