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

  Future<bool> pingPeer(PeerId peerId) => router
      .pingPeer(P2PPeerId(value: peerId.token))
      .timeout(const Duration(seconds: 3));

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
  Timer? _keepaliveTimer;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (kDebugMode) print(state);
    if (state == AppLifecycleState.resumed) {
      _connectivityType = await _connectivity.checkConnectivity();
      if (_connectivityType == ConnectivityResult.none) return;
      await router.start();
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
    for (final i in await NetworkInterface.list()) {
      _myAddresses.addAll(i.addresses.map(
        (a) => PeerAddress(address: a, port: P2PRouterBase.defaultPort),
      ));
    }
    WidgetsBinding.instance.addObserver(this);
    final cryptoKeys = await router.init(keyBunch.isEmpty
        ? null
        : P2PCryptoKeys(
            encSeed: emptyUint8List,
            encPublicKey: keyBunch.encryptionPublicKey,
            encPrivateKey: keyBunch.encryptionPrivateKey,
            signSeed: emptyUint8List,
            signPublicKey: keyBunch.signPublicKey,
            signPrivateKey: keyBunch.signPrivateKey,
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
      encryptionAesKey: keyBunch.encryptionAesKey.isEmpty
          ? getRandomBytes(KeyBunch.aesKeyLength)
          : keyBunch.encryptionAesKey,
    );
  }

  void onMessage(final P2PMessage p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  void setBootstrapServer([
    String ipV4 = '',
    String ipV6 = '',
    int port = P2PRouterBase.defaultPort,
    String peerId = '', // TBD: get from env (Globals)
  ]) {
    final bsPeerId = P2PPeerId(
      value: peerId.isEmpty
          ? getRandomBytes(P2PPeerId.length)
          : base64Decode(peerId),
    );
    if (ipV4.isEmpty && ipV6.isEmpty) {
      _keepaliveTimer?.cancel();
      router.forgetPeerId(bsPeerId);
    } else {
      router.addPeerAddresses(
        peerId: bsPeerId,
        addresses: [
          if (ipV4.isNotEmpty)
            P2PFullAddress(
              address: InternetAddress(ipV4),
              port: port,
              isLocal: false,
            ),
          if (ipV6.isNotEmpty)
            P2PFullAddress(
              address: InternetAddress(ipV6),
              port: port,
              isLocal: false,
            ),
        ],
      );
      router.sendMessage(dstPeerId: bsPeerId);
      _keepaliveTimer = Timer.periodic(
        const Duration(seconds: 15),
        (_) => router.sendMessage(dstPeerId: bsPeerId),
      );
    }
  }
}