import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import 'services/mdns_service.dart';
import 'services/platform_service.dart';
import 'services/preferences_service.dart';

enum NetworkManagerState { uninited, stopped, started, pending }

class NetworkManager {
  NetworkManager({
    this.port = defaultPort,
    final p2p.RouterL2? router,
    final MdnsService? mdnsService,
  }) {
    _router = router ??
        p2p.RouterL2(
          transports: [],
          messageTTL: retryNetworkTimeout,
          keepalivePeriod: keepalivePeriod,
          logger: kDebugMode ? print : null,
        )
      ..maxForwardsLimit = maxForwardsLimit
      ..maxStoredHeaders = maxStoredHeaders;
    _mdnsService = mdnsService ??
        MdnsService(
          onPeerFound: (peerId, address, port) => _router.addPeerAddress(
            peerId: p2p.PeerId(value: peerId),
            properties: _addressProperties,
            address: p2p.FullAddress(address: address, port: port ?? this.port),
          ),
        );
    _connectivityChanges.resume();
  }

  final int port;

  late final selfId = _router.selfId.value;

  late final messageStream = _router.messageStream
      .map((e) => MessageModel.fromBytes(e.payload!))
      .asBroadcastStream();

  late final peerStatusChangeStream = _router.lastSeenStream
      .map((e) => (PeerId(token: e.peerId.value), e.isOnline));

  final _platformService = GetIt.I<PlatformService>();
  final _preferencesService = GetIt.I<PreferencesService>();

  final _addressProperties = p2p.AddressProperties(
    isLocal: true,
    isStatic: true,
  );

  late final p2p.RouterL2 _router;
  late final MdnsService _mdnsService;

  late final _connectivityChanges =
      _platformService.onConnectivityChanged.listen((state) async {
    if (state.hasConnectivity) {
      await stop();
      await start();
    } else {
      await stop();
    }
  });

  NetworkManagerState _state = NetworkManagerState.uninited;

  Future<NetworkManager> init() async {
    if (_state != NetworkManagerState.uninited) throw Exception('Init once!');
    _state = NetworkManagerState.pending;
    final seed = await _preferencesService.get<Uint8List>(keySeed);
    if (seed == null) {
      await _preferencesService.set<Uint8List>(
        keySeed,
        await _router.init().timeout(initTimeout),
      );
    } else {
      await _router.init(seed).timeout(initTimeout);
    }
    toggleBootstrap(await _preferencesService.get<bool>(keyIsBootstrapEnabled));
    _state = NetworkManagerState.stopped;
    return this;
  }

  Future<void> start() async {
    if (_state != NetworkManagerState.stopped) return;
    _state = NetworkManagerState.pending;

    await _platformService.checkConnectivity();
    if (_platformService.hasNoConnectivity) {
      _state = NetworkManagerState.stopped;
      return;
    }
    for (final address in await _platformService.getIPs()) {
      _router.transports.add(p2p.TransportUdp(
        bindAddress: p2p.FullAddress(address: address, port: port),
      ));
    }
    await _router.start();

    if (_platformService.hasWiFi) {
      await _mdnsService.register(_router.selfId.value, port);
      await _mdnsService.startDiscovery();
    }
    _state = NetworkManagerState.started;
  }

  Future<void> stop() async {
    if (_state != NetworkManagerState.started) return;
    _state = NetworkManagerState.pending;
    _router.stop();
    _router.transports.clear();
    await _mdnsService.stopDiscovery();
    await _mdnsService.unregister();
    _state = NetworkManagerState.stopped;
  }

  Future<void> sendToPeer(
    PeerId peerId, {
    required MessageModel message,
    bool isConfirmable = false,
  }) async {
    if (peerId.isEmpty) return;
    try {
      await _router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } catch (_) {
      if (isConfirmable) rethrow;
    }
  }

  bool getPeerStatus(PeerId peerId) =>
      _router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(PeerId peerId) =>
      _router.pingPeer(p2p.PeerId(value: peerId.token));

  void toggleBootstrap([bool? isActive]) {
    if (bsPeerId.isEmpty) return;
    final peerId = p2p.PeerId(value: base64Decode(bsPeerId));
    if (isActive == true) {
      final addressProperties = p2p.AddressProperties(isStatic: true);
      if (bsAddressV4.isNotEmpty) {
        _router.addPeerAddress(
          canForward: true,
          peerId: peerId,
          address: p2p.FullAddress(
            address: InternetAddress(bsAddressV4),
            port: bsPort,
          ),
          properties: addressProperties,
        );
      }
      if (bsAddressV6.isNotEmpty) {
        _router.addPeerAddress(
          canForward: true,
          peerId: peerId,
          address: p2p.FullAddress(
            address: InternetAddress(bsAddressV6),
            port: bsPort,
          ),
          properties: addressProperties,
        );
      }
      if (_router.isRun) _router.sendMessage(dstPeerId: peerId);
    } else {
      _router.removePeerAddress(peerId);
    }
  }

  // void _onPeerFound(
  //   Uint8List peerId,
  //   InternetAddress address,
  //   int? port,
  // ) =>
  //     _router.addPeerAddress(
  //       peerId: p2p.PeerId(value: peerId),
  //       properties: _addressProperties,
  //       address: p2p.FullAddress(address: address, port: port ?? this.port),
  //     );
}
