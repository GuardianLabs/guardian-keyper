import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/_id/peer_id.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import 'preferences_service.dart';
import 'platform_service.dart';

class NetworkManager {
  NetworkManager({
    this.port = defaultPort,
    final p2p.RouterL2? router,
  }) : router = router ??
            p2p.RouterL2(
              transports: [],
              messageTTL: retryNetworkTimeout,
              keepalivePeriod: keepalivePeriod,
              logger: kDebugMode ? print : null,
            )
          ..maxForwardsLimit = maxForwardsLimit
          ..maxStoredHeaders = maxStoredHeaders;

  final int port;
  final p2p.RouterL2 router;

  Uint8List get selfId => router.selfId.value;

  Duration get messageTTL => router.messageTTL;

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<(PeerId, bool)> get peerStatusChangeStream =>
      router.lastSeenStream.map((e) => (PeerId(token: e.key.value), e.value));

  final _platformService = GetIt.I<PlatformService>();
  final _preferencesService = GetIt.I<PreferencesService>();
  final _messagesController = StreamController<MessageModel>.broadcast();

  Future<NetworkManager> init() async {
    final seed =
        await _preferencesService.get<Uint8List>(keySeed) ?? Uint8List(0);
    final cryptoKeys = await router
        .init(p2p.CryptoKeys.empty()..seed = seed)
        .timeout(initTimeout);
    if (seed.isEmpty) {
      await _preferencesService.set<Uint8List>(keySeed, cryptoKeys.seed);
    }
    router.messageStream.listen((p2pMessage) {
      final message = MessageModel.tryFromBytes(p2pMessage.payload);
      if (message != null) _messagesController.add(message);
    });
    return this;
  }

  Future<void> start() async {
    await _platformService.checkConnectivity();
    if (_platformService.hasNoConnectivity) return;
    for (final address in await _platformService.getIPs()) {
      router.transports.add(p2p.TransportUdp(
        bindAddress: p2p.FullAddress(address: address, port: port),
      ));
    }
    toggleBootstrap(await _preferencesService.get<bool>(keyIsBootstrapEnabled));
    await router.start();
  }

  void pause() {
    router.stop();
    router.transports.clear();
  }

  Future<void> sendTo(
    PeerId peerId, {
    required MessageModel message,
    bool isConfirmable = false,
  }) async {
    try {
      await router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } catch (_) {
      if (isConfirmable) rethrow;
    }
  }

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(PeerId peerId) =>
      router.pingPeer(p2p.PeerId(value: peerId.token));

  void toggleBootstrap([bool? isActive]) {
    if (bsPeerId.isEmpty) return;
    final peerId = p2p.PeerId(value: base64Decode(bsPeerId));
    if (isActive == true) {
      final addressProperties = p2p.AddressProperties(isStatic: true);
      if (bsAddressV4.isNotEmpty) {
        router.addPeerAddress(
          canForward: true,
          peerId: peerId,
          address: p2p.FullAddress(
            address: InternetAddress(bsAddressV4),
            port: port,
          ),
          properties: addressProperties,
        );
      }
      if (bsAddressV6.isNotEmpty) {
        router.addPeerAddress(
          canForward: true,
          peerId: peerId,
          address: p2p.FullAddress(
            address: InternetAddress(bsAddressV6),
            port: port,
          ),
          properties: addressProperties,
        );
      }
      if (router.isRun) router.sendMessage(dstPeerId: peerId);
    } else {
      router.removePeerAddress(peerId);
    }
  }
}
