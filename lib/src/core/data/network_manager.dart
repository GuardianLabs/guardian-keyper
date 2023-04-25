import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../consts.dart';
import '../domain/entity/core_model.dart';
import 'preferences_manager.dart';
import 'platform_manager.dart';

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

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  final _env = GetIt.I<Env>();
  final _platformManager = GetIt.I<PlatformManager>();
  final _preferencesManager = GetIt.I<PreferencesManager>();
  final _messagesController = StreamController<MessageModel>.broadcast();

  Future<NetworkManager> init() async {
    final seed =
        await _preferencesManager.get<Uint8List>(keySeed) ?? Uint8List(0);
    final cryptoKeys = await router
        .init(p2p.CryptoKeys.empty()..seed = seed)
        .timeout(initTimeout);
    if (seed.isEmpty) {
      await _preferencesManager.set<Uint8List>(keySeed, cryptoKeys.seed);
    }
    router.messageStream.listen((final p2p.Message p2pMessage) {
      final message = MessageModel.tryFromBytes(p2pMessage.payload);
      if (message != null && message.version == MessageModel.currentVersion) {
        _messagesController.add(message);
      }
    });
    return this;
  }

  Future<void> start([void _]) async {
    await _platformManager.checkConnectivity();
    if (_platformManager.hasNoConnectivity) return;
    for (final address in await _platformManager.getIPs()) {
      router.transports.add(p2p.TransportUdp(
        bindAddress: p2p.FullAddress(address: address, port: port),
      ));
    }
    await router.start();
    toggleBootstrap(await _preferencesManager.get<bool>(keyIsBootstrapEnabled));
  }

  void pause([void _]) {
    router.stop();
    router.transports.clear();
  }

  void stop([void _]) {
    router.stop();
  }

  Future<void> sendTo({
    required final PeerId peerId,
    required final MessageModel message,
    required final bool isConfirmable,
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

  bool getPeerStatus(final PeerId peerId) =>
      router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(final PeerId peerId) =>
      router.pingPeer(p2p.PeerId(value: peerId.token));

  void toggleBootstrap([bool? isActive]) {
    if (_env.bsPeerId.isEmpty) return;
    final bsPeerId = p2p.PeerId(value: base64Decode(_env.bsPeerId));
    if (isActive == true) {
      final addressProperties = p2p.AddressProperties(isStatic: true);
      if (_env.bsAddressV4.isNotEmpty) {
        router.addPeerAddress(
          canForward: true,
          peerId: bsPeerId,
          address: p2p.FullAddress(
            address: InternetAddress(_env.bsAddressV4),
            port: _env.bsPort,
          ),
          properties: addressProperties,
        );
      }
      if (_env.bsAddressV6.isNotEmpty) {
        router.addPeerAddress(
          canForward: true,
          peerId: bsPeerId,
          address: p2p.FullAddress(
            address: InternetAddress(_env.bsAddressV6),
            port: _env.bsPort,
          ),
          properties: addressProperties,
        );
      }
      if (router.isRun) router.sendMessage(dstPeerId: bsPeerId);
    } else {
      router.removePeerAddress(bsPeerId);
    }
  }
}
