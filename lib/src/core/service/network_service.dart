import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:p2plib/p2plib.dart';

import '../model/core_model.dart';

part 'network_service_handler.dart';

abstract class NetworkServiceBase {
  final P2PRouter router;

  final _messagesController = StreamController<MessageModel>.broadcast();

  NetworkServiceBase({P2PRouter? router})
      : router = router ?? P2PRouter(logger: kDebugMode ? print : null);

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  List<PeerAddress> get myAddresses => router.selfAddresses
      .map((e) => PeerAddress(address: e.address, port: e.port))
      .toList();

  void addPeer(PeerId peerId, Uint8List address) {
    final ip = InternetAddress.fromRawAddress(address);
    if (ip == InternetAddress.loopbackIPv4 ||
        ip == InternetAddress.loopbackIPv6) return;
    router.addPeerAddress(
      peerId: P2PPeerId(value: peerId.token),
      addresses: [P2PFullAddress(address: ip, port: router.defaultPort)],
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
  }) =>
      router
          .sendMessage(
            isConfirmable: withAck,
            dstPeerId: P2PPeerId(value: peerId.token),
            payload: message.toBytes(),
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);
}

class NetworkService extends NetworkServiceBase
    with WidgetsBindingObserver, ConnectivityHandler, MdnsHandler {
  Timer? _keepaliveTimer;

  NetworkService({super.router}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
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
    _mdnsInit(router.defaultPort, base64Encode(router.selfId.value));
    await _connectivityInit();
    await didChangeAppLifecycleState(AppLifecycleState.resumed);
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
    if (p2pMessage.isEmpty) return;
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    if (message.peerId != PeerId(token: p2pMessage.srcPeerId.value)) return;
    _messagesController.add(message);
  }

  void setBootstrapServer([
    String ipV4 = '',
    String ipV6 = '',
    int port = 0,
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
      router.addPeerAddress(
        peerId: bsPeerId,
        addresses: [
          if (ipV4.isNotEmpty)
            P2PFullAddress(
              address: InternetAddress(ipV4),
              port: port == 0 ? router.defaultPort : port,
            ),
          if (ipV6.isNotEmpty)
            P2PFullAddress(
              address: InternetAddress(ipV6),
              port: port == 0 ? router.defaultPort : port,
            ),
        ],
      );
      router.sendMessage(dstPeerId: bsPeerId);
      _keepaliveTimer = Timer.periodic(
        router.peerAddressTTL * 0.5,
        (_) => router.sendMessage(dstPeerId: bsPeerId),
      );
    }
  }
}
