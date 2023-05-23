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

class NetworkManager {
  NetworkManager({
    int port = defaultPort,
    final p2p.RouterL2? router,
    final MdnsService? mdnsService,
  }) : _port = port {
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
            address: p2p.FullAddress(address: address, port: port ?? _port),
          ),
        );
  }

  Uint8List get selfId => _router.selfId.value;

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<(PeerId, bool)> get peerStatusChangeStream => _router.lastSeenStream
      .map((e) => (PeerId(token: e.peerId.value), e.isOnline));

  final int _port;
  late final p2p.RouterL2 _router;
  late final MdnsService _mdnsService;

  final _platformService = GetIt.I<PlatformService>();
  final _preferencesService = GetIt.I<PreferencesService>();
  final _messagesController = StreamController<MessageModel>.broadcast();
  final _addressProperties = p2p.AddressProperties(
    isLocal: true,
    isStatic: true,
  );

  Future<NetworkManager> init() async {
    final seed = await _preferencesService.get<Uint8List>(keySeed);
    if (seed == null) {
      await _preferencesService.set<Uint8List>(
        keySeed,
        await _router.init().timeout(initTimeout),
      );
    } else {
      await _router.init(seed).timeout(initTimeout);
    }
    _router.messageStream.listen((p2pMessage) {
      final message = MessageModel.tryFromBytes(p2pMessage.payload);
      if (message != null) _messagesController.add(message);
    });
    await _mdnsService.register(_router.selfId.value, _port);
    return this;
  }

  Future<void> start() async {
    await _platformService.checkConnectivity();
    if (_platformService.hasNoConnectivity) return;
    for (final address in await _platformService.getIPs()) {
      _router.transports.add(p2p.TransportUdp(
        bindAddress: p2p.FullAddress(address: address, port: _port),
      ));
    }
    await _router.start();
    if (_platformService.hasWiFi) await _mdnsService.startDiscovery();
    toggleBootstrap(await _preferencesService.get<bool>(keyIsBootstrapEnabled));
  }

  Future<void> pause() async {
    _router.stop();
    _router.transports.clear();
    await _mdnsService.stopDiscovery();
  }

  Future<void> dispose() => (
        _platformService.wakelockDisable(),
        _mdnsService.unregister(),
      ).wait;

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
}
