import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

class RouterService {
  RouterService({p2p.RouterL2? router})
      : _router = router ??
            p2p.RouterL2(
              transports: [],
              keepalivePeriod: keepalivePeriod,
              logger: kDebugMode ? print : null,
            )
          ..maxForwardsLimit = maxForwardsLimit
          ..maxStoredHeaders = maxStoredHeaders;

  late final p2p.RouterL2 _router;

  late final selfId = _router.selfId.value;

  late final messageStream = _router.messageStream
      .map((e) => MessageModel.fromBytes(e.payload!))
      .asBroadcastStream();

  late final peerStatusChanges = _router.lastSeenStream
      .map((e) => (PeerId(token: e.peerId.value), e.isOnline));

  Future<Uint8List> init([Uint8List? seed]) => _router.init(seed);

  Future<void> start(int port) async {
    final ifs = <InternetAddress>{};
    for (final nIf in await NetworkInterface.list()) {
      ifs.addAll(nIf.addresses);
    }
    for (final address in ifs) {
      _router.transports.add(p2p.TransportUdp(
        bindAddress: p2p.FullAddress(address: address, port: port),
      ));
    }
    await _router.start();
  }

  void stop() {
    _router.stop();
    _router.transports.clear();
  }

  Future<bool> pingPeer(PeerId peerId) =>
      _router.pingPeer(p2p.PeerId(value: peerId.token));

  bool getPeerStatus(PeerId peerId) =>
      _router.getPeerStatus(p2p.PeerId(value: peerId.token));

  void addPeerAddress({
    required Uint8List peerId,
    required InternetAddress address,
    required int port,
  }) =>
      _router.addPeerAddress(
        peerId: p2p.PeerId(value: peerId),
        address: p2p.FullAddress(address: address, port: port),
        properties: p2p.AddressProperties(isLocal: true, isStatic: true),
      );

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

  void toggleBootstrap({
    required bool isActive,
    required Map<String, List<InternetAddress>> addresses,
  }) {
    final addressProperties = p2p.AddressProperties(isStatic: true);
    for (final e in addresses.entries) {
      final peerId = p2p.PeerId(value: base64Decode(e.key));
      if (isActive) {
        for (final address in e.value) {
          _router.addPeerAddress(
            canForward: true,
            peerId: peerId,
            address: p2p.FullAddress(address: address, port: bsPort),
            properties: addressProperties,
          );
        }
      } else {
        _router.removePeerAddress(peerId);
      }
    }
  }
}
