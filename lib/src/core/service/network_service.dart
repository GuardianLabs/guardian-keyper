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

  final _guardianStreamController = StreamController<MessageModel>.broadcast();
  final _vaultStreamController = StreamController<MessageModel>.broadcast();
  final _emptyPeerId = P2PPeerId(value: Uint8List(64));
  final P2PRouter router;
  late final BonsoirService _bonsoirService;

  StreamSubscription<BonsoirDiscoveryEvent>? _mDNSsubscription;
  BonsoirDiscovery? _mDNSdiscovery;
  BonsoirBroadcast? _mDNSbroadcast;

  var mDNSenabled = true;

  Stream<MessageModel> get guardianStream => _guardianStreamController.stream;

  Stream<MessageModel> get recoveryGroupStream => _vaultStreamController.stream;

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
        _mDNSbroadcast = BonsoirBroadcast(service: _bonsoirService);
        await _mDNSbroadcast!.ready;
        await _mDNSbroadcast!.start();
        _mDNSdiscovery = BonsoirDiscovery(type: _bonsoirType);
        await _mDNSdiscovery!.ready;
        _mDNSsubscription = _mDNSdiscovery!.eventStream!.listen(onBonsoirEvent);
        await _mDNSdiscovery!.start();
      }
    } else {
      router.stop();
      _mDNSsubscription?.cancel();
      await _mDNSbroadcast?.stop();
      await _mDNSdiscovery?.stop();
      _mDNSbroadcast = null;
      _mDNSdiscovery = null;
    }
  }

  Future<KeyBunch> init(KeyBunch keyBunch) async {
    final cryptoKeys = await router.init(keyBunch.isEmpty
        ? null
        : P2PCryptoKeys(
            encSeed: keyBunch.encryptionSeed,
            encPublicKey: keyBunch.encryptionPublicKey,
            encPrivateKey: keyBunch.encryptionPrivateKey,
            signSeed: keyBunch.signSeed,
            signPublicKey: keyBunch.signPublicKey,
            signPrivateKey: keyBunch.signPrivateKey,
          ));
    _bonsoirService = BonsoirService(
      name: _bonsoirName,
      type: _bonsoirType,
      port: router.defaultPort,
      attributes: {_bonsoirAttr: base64Encode(router.selfId.value)},
    );
    WidgetsBinding.instance.addObserver(this);
    await didChangeAppLifecycleState(AppLifecycleState.resumed);
    return KeyBunch(
      encryptionSeed: cryptoKeys.encSeed,
      encryptionPrivateKey: cryptoKeys.encPrivateKey,
      encryptionPublicKey: cryptoKeys.encPublicKey,
      signSeed: cryptoKeys.signSeed,
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

    switch (message.payloadTypeId) {
      case PeerAddressList.typeId:
        // TBD: find if controllers works with that type
        throw Exception('Need to choose stream!');
      case SecretShardModel.typeId:
        _guardianStreamController.add(message);
        break;
      case RecoveryGroupModel.typeId:
        _vaultStreamController.add(message);
        break;
    }
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
      router.pingPeer(peerId);
    }
  }

  void setBootstrapServer([
    String ipV4 = '',
    String ipV6 = '',
    int port = 0,
    String peerId = '', // TBD: parse from hex
  ]) {
    if (ipV4.isEmpty && ipV6.isEmpty) {
      router.forgetPeerId(_emptyPeerId);
    } else {
      router.addPeerAddress(
        peerId: _emptyPeerId,
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
    }
  }

  void addPeer(PeerId peerId, Uint8List address) => router.addPeerAddress(
        peerId: P2PPeerId(value: peerId.token),
        addresses: [
          P2PFullAddress(
            address: InternetAddress.fromRawAddress(address),
            port: router.defaultPort,
          )
        ],
      );

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(P2PPeerId(value: peerId.token));

  Future<bool> pingPeer({required PeerId peerId}) =>
      router.pingPeer(P2PPeerId(value: peerId.token));

  StreamSubscription<bool> onPeerStatusChanged(
    void Function(bool) callback,
    PeerId peerId,
  ) =>
      router.trackPeer(
        onChange: callback,
        peerId: P2PPeerId(value: peerId.token),
      );

  Future<void> sendToRecoveryGroup({
    required PeerId peerId,
    required MessageModel message,
    bool withAck = true,
  }) =>
      router
          .sendMessage(
            isConfirmable: withAck,
            dstPeerId: P2PPeerId(value: peerId.token),
            payload: message.toBytes(),
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);

  Future<void> sendToGuardian({
    required PeerId peerId,
    required MessageModel message,
    bool withAck = true,
  }) =>
      router
          .sendMessage(
            isConfirmable: withAck,
            dstPeerId: P2PPeerId(value: peerId.token),
            payload: message.toBytes(),
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);
}
