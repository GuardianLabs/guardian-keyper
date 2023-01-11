import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:p2plib/p2plib.dart';

import '../model/core_model.dart';

class NetworkService with WidgetsBindingObserver {
  static const _bonsoirType = '_dartshare._udp';
  static const _bonsoirAttr = 'peer_id';
  static const _bonsoirName = 'Guardian Keyper';

  final P2PRouter router;
  final _messagesController = StreamController<MessageModel>.broadcast();
  // TBD: get from env
  final _bsPeerId = P2PPeerId(value: getRandomBytes(P2PPeerId.length));
  late final BonsoirService _bonsoirService;
  late final BonsoirDiscovery _mDNSdiscovery;
  late final BonsoirBroadcast _mDNSbroadcast;
  late StreamSubscription<BonsoirDiscoveryEvent> _mDNSsubscription;

  var mDNSenabled = true;

  Timer? _keepaliveTimer;

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  List<PeerAddress> get myAddresses => router.selfAddresses
      .map((e) => PeerAddress(address: e.address, port: e.port))
      .toList();

  NetworkService({P2PRouter? router, this.mDNSenabled = true})
      : router = router ?? P2PRouter(logger: kDebugMode ? print : null);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await router.start();
      if (mDNSenabled) {
        await _mDNSbroadcast.ready;
        await _mDNSbroadcast.start();
        await _mDNSdiscovery.ready;
        _mDNSsubscription = _mDNSdiscovery.eventStream!.listen(onBonsoirEvent);
        await _mDNSdiscovery.start();
      }
    } else {
      router.stop();
      _mDNSsubscription.cancel();
      await _mDNSbroadcast.stop();
      await _mDNSdiscovery.stop();
    }
  }

  Future<KeyBunch> init(KeyBunch keyBunch) async {
    router.messageStream.listen(onMessage);
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
    _bonsoirService = BonsoirService(
      name: _bonsoirName,
      type: _bonsoirType,
      port: router.defaultPort,
      attributes: {_bonsoirAttr: base64Encode(router.selfId.value)},
    );
    _mDNSbroadcast = BonsoirBroadcast(service: _bonsoirService);
    _mDNSdiscovery = BonsoirDiscovery(type: _bonsoirType);
    WidgetsBinding.instance.addObserver(this);
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

  void onBonsoirEvent(BonsoirDiscoveryEvent event) {
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      final eventMap = event.service?.toJson();
      if (eventMap == null) return;
      if (eventMap['service.type'] != _bonsoirType) return;
      if (eventMap['service.name'] != _bonsoirName) return;
      final peerId = P2PPeerId(
        value: base64Decode(eventMap['service.attributes']?[_bonsoirAttr]),
      );
      if (peerId == router.selfId) return;
      router.addPeerAddress(
        peerId: peerId,
        addresses: [
          P2PFullAddress(
            address: InternetAddress(eventMap['service.ip']),
            port: event.service!.port,
          ),
        ],
      );
    }
  }

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

  Future<bool> pingPeer(PeerId peerId) =>
      router.pingPeer(P2PPeerId(value: peerId.token));

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

  void setBootstrapServer([
    String ipV4 = '',
    String ipV6 = '',
    int port = 0,
    String peerId = '', // TBD: parse from base64
  ]) {
    if (ipV4.isEmpty && ipV6.isEmpty) {
      _keepaliveTimer?.cancel();
      router.forgetPeerId(_bsPeerId);
    } else {
      router.addPeerAddress(
        peerId: _bsPeerId,
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
      router.sendMessage(dstPeerId: _bsPeerId);
      _keepaliveTimer = Timer.periodic(
        router.peerAddressTTL * 0.5,
        (_) => router.sendMessage(dstPeerId: _bsPeerId),
      );
    }
  }
}
