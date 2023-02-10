import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../model/core_model.dart';

part 'p2p_network_service_handler.dart';

abstract class P2PNetworkServiceBase {
  final p2p.RouterL2 router;
  final bindPort = p2p.TransportUdp.defaultPort;

  final _myAddresses = <PeerAddress>[];
  final _messagesController = StreamController<MessageModel>.broadcast();

  P2PNetworkServiceBase({
    Duration keepalivePeriod = const Duration(seconds: 10),
  }) : router = p2p.RouterL2(
          logger: kDebugMode ? print : null,
          keepalivePeriod: keepalivePeriod,
        );

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
      peerId: p2p.PeerId(value: peerId.token),
      address: p2p.FullAddress(address: ip, port: port, isLocal: isLocal),
    );
  }

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(PeerId peerId) =>
      router.pingPeer(p2p.PeerId(value: peerId.token));

  Future<void> sendTo({
    required PeerId peerId,
    required MessageModel message,
    required bool withAck,
  }) async {
    try {
      await router.sendMessage(
        isConfirmable: withAck,
        dstPeerId: p2p.PeerId(value: peerId.token),
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

  p2p.Route? _bsServer;

  P2PNetworkService({super.keepalivePeriod});

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
        (a) => PeerAddress(address: a, port: bindPort),
      ));
    }
    WidgetsBinding.instance.addObserver(this);
    final cryptoKeys = await router.init(keyBunch.isEmpty
        ? null
        : p2p.CryptoKeys(
            encPublicKey: keyBunch.encryptionPublicKey,
            encPrivateKey: keyBunch.encryptionPrivateKey,
            signPublicKey: keyBunch.signPublicKey,
            signPrivateKey: keyBunch.signPrivateKey,
            seed: keyBunch.encryptionAesKey,
          ));
    router.messageStream.listen(onMessage);
    await _connectivityInit();
    await _mdnsInit(bindPort, base64Encode(router.selfId.value));
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

  void onMessage(final p2p.Message p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  void setBootstrapServer({
    required String peerId,
    String ipV4 = '',
    String ipV6 = '',
    int? port,
  }) {
    final bsPeerId = p2p.PeerId(value: base64Decode(peerId));
    if (ipV4.isEmpty && ipV6.isEmpty) {
      _bsServer = null;
      router.routes.remove(bsPeerId);
    } else {
      final timestamp = DateTime.now().add(bsDelta).millisecondsSinceEpoch;
      final bsRoute = p2p.Route(
        peerId: bsPeerId,
        canForward: true,
        addresses: {
          if (ipV4.isNotEmpty && myAddresses.any((e) => e.isIPv4))
            p2p.FullAddress(
              address: InternetAddress(ipV4),
              port: port ?? bindPort,
              isLocal: false,
              isStatic: true,
            ): timestamp,
          if (ipV6.isNotEmpty && myAddresses.any((e) => e.isIPv6))
            p2p.FullAddress(
              address: InternetAddress(ipV6),
              port: port ?? bindPort,
              isLocal: false,
              isStatic: true,
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
