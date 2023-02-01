import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:p2plib/p2plib.dart';

import '../model/core_model.dart';

part 'p2p_network_service_handler.dart';

abstract class P2PNetworkServiceBase {
  final router = P2PRouterL2(logger: kDebugMode ? print : null);

  final _myAddresses = <PeerAddress>[];
  final _messagesController = StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  List<PeerAddress> get myAddresses => _myAddresses;

  void addPeer(
    PeerId peerId,
    Uint8List address,
    int port, [
    bool isLocal = true,
  ]) {
    final ip = InternetAddress.fromRawAddress(address);
    if (ip == InternetAddress.loopbackIPv4 ||
        ip == InternetAddress.loopbackIPv6) return;
    router.addPeerAddress(
      peerId: P2PPeerId(value: peerId.token),
      address: P2PFullAddress(address: ip, port: port, isLocal: isLocal),
    );
  }

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(P2PPeerId(value: peerId.token));

  Future<bool> pingPeer(PeerId peerId) =>
      router.pingPeer(P2PPeerId(value: peerId.token));

  Future<void> sendTo({
    required PeerId peerId,
    required MessageModel message,
    required bool withAck,
  }) async {
    try {
      await router.sendMessage(
        isConfirmable: withAck,
        dstPeerId: P2PPeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } on TimeoutException {
      // No need to handle
    }
  }
}

class P2PNetworkService extends P2PNetworkServiceBase
    with WidgetsBindingObserver, P2PConnectivityHandler, P2PMdnsHandler {
  final bsDelta = const Duration(minutes: 5);

  P2PRoute? _bsServer;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (kDebugMode) print(state);
    if (state == AppLifecycleState.resumed) {
      _connectivityType = await _connectivity.checkConnectivity();
      if (kDebugMode) print(_connectivityType);
      if (_connectivityType == ConnectivityResult.none) return;
      await router.start();
      if (_bsServer != null) {
        router.addPeerAddresses(
          canForward: true,
          peerId: _bsServer!.peerId,
          addresses: _bsServer!.addresses.keys,
          timestamp: DateTime.now().add(bsDelta).millisecondsSinceEpoch,
        );
        router.sendMessage(dstPeerId: _bsServer!.peerId);
      }
      if (_connectivityType == ConnectivityResult.wifi) {
        await startMdnsBroadcast();
        await startMdnsDiscovery();
      }
    } else {
      router.stop();
      await stopMdnsBroadcast();
      await stopMdnsDiscovery();
    }
  }

  Future<KeyBunch> init(KeyBunch keyBunch) async {
    for (final interface in await NetworkInterface.list()) {
      _myAddresses.addAll(interface.addresses.map(
        (a) => PeerAddress(address: a, port: P2PRouterBase.defaultPort),
      ));
    }
    WidgetsBinding.instance.addObserver(this);
    final cryptoKeys = await router.init(keyBunch.isEmpty
        ? null
        : P2PCryptoKeys(
            encPublicKey: keyBunch.encryptionPublicKey,
            encPrivateKey: keyBunch.encryptionPrivateKey,
            signPublicKey: keyBunch.signPublicKey,
            signPrivateKey: keyBunch.signPrivateKey,
            seed: keyBunch.encryptionAesKey,
          ));
    router.messageStream.listen(onMessage);
    await _connectivityInit();
    await _mdnsInit(
      P2PRouterBase.defaultPort,
      base64Encode(router.selfId.value),
    );
    if (kDebugMode) {
      print(_myAddresses);
      print(router.selfId);
    }
    return KeyBunch(
      encryptionPrivateKey: cryptoKeys.encPrivateKey,
      encryptionPublicKey: cryptoKeys.encPublicKey,
      signPrivateKey: cryptoKeys.signPrivateKey,
      signPublicKey: cryptoKeys.signPublicKey,
      encryptionAesKey: cryptoKeys.seed,
    );
  }

  void onMessage(final P2PMessage p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  void setBootstrapServer({
    required String peerId,
    String ipV4 = '',
    String ipV6 = '',
    int port = P2PRouterBase.defaultPort,
  }) {
    final bsPeerId = P2PPeerId(value: base64Decode(peerId));
    if (ipV4.isEmpty && ipV6.isEmpty) {
      _bsServer = null;
      router.forgetPeerId(bsPeerId);
    } else {
      final timestamp = DateTime.now().add(bsDelta).millisecondsSinceEpoch;
      final bsRoute = P2PRoute(
        peerId: bsPeerId,
        canForward: true,
        addresses: {
          if (ipV4.isNotEmpty && myAddresses.any((e) => e.isIPv4))
            P2PFullAddress(
              address: InternetAddress(ipV4),
              port: port,
              isLocal: false,
            ): timestamp,
          if (ipV6.isNotEmpty && myAddresses.any((e) => e.isIPv6))
            P2PFullAddress(
              address: InternetAddress(ipV6),
              port: port,
              isLocal: false,
            ): timestamp,
        },
      );
      router.addPeerAddresses(
        canForward: true,
        peerId: bsPeerId,
        addresses: bsRoute.addresses.keys,
        timestamp: timestamp,
      );
      if (kDebugMode) {
        print('See ${router.routes.length} existing routes');
        print('Bootstrap addresses: ${router.routes[bsPeerId]?.addresses}');
      }
      if (router.isRun) router.sendMessage(dstPeerId: bsPeerId);
    }
  }
}
