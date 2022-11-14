import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:bonsoir/bonsoir.dart';
import 'package:p2plib/p2plib.dart';

import '../model/core_model.dart';

class NetworkService extends TopicHandler with WidgetsBindingObserver {
  static const _bonsoirType = '_dartshare._udp';
  static const _bonsoirAttr = 'peer_id';
  static const _bonsoirName = 'Guardian Keyper';
  static const _topicOfRecoveryGroup = 100;
  static const _topicOfGuardian = 101;

  final _guardianStreamController = StreamController<MessageModel>.broadcast();
  final _vaultStreamController = StreamController<MessageModel>.broadcast();
  final BonsoirService _bonsoirService;
  StreamSubscription<BonsoirDiscoveryEvent>? _mDNSsubscription;
  BonsoirDiscovery? _mDNSdiscovery;
  BonsoirBroadcast? _mDNSbroadcast;
  bool mDNSenabled;

  NetworkService({
    required Router router,
    this.mDNSenabled = true,
  })  : _bonsoirService = BonsoirService(
          name: _bonsoirName,
          type: _bonsoirType,
          port: router.connection.ipv4Port,
          attributes: {_bonsoirAttr: base64Encode(router.pubKey.data)},
        ),
        super(router) {
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => didChangeAppLifecycleState(AppLifecycleState.resumed),
    );
  }

  factory NetworkService.udp({
    required KeyBunch keyBunch,
    String bsAddressV4 = '',
    String bsAddressV6 = '',
    int bsPort = 4349,
  }) =>
      NetworkService(
        router: Router(
          UdpConnection(),
          encryptionKeyPair: KeyPairData(
            pubKey: keyBunch.encryptionPublicKey,
            secretKey: keyBunch.encryptionPrivateKey,
          ),
          signKeyPair: KeyPairData(
            pubKey: keyBunch.singPublicKey,
            secretKey: keyBunch.singPrivateKey,
          ),
          bootstrapServerAddress: bsAddressV4.isEmpty
              ? null
              : Peer(
                  InternetAddress(bsAddressV4, type: InternetAddressType.IPv4),
                  bsPort,
                ),
          bootstrapServerAddressIpv6: bsAddressV6.isEmpty
              ? null
              : Peer(
                  InternetAddress(bsAddressV6, type: InternetAddressType.IPv6),
                  bsPort,
                ),
        ),
      );

  Stream<MessageModel> get guardianStream => _guardianStreamController.stream;

  Stream<MessageModel> get recoveryGroupStream => _vaultStreamController.stream;

  List<PeerAddress> get myAddresses => [
        for (final address in router.connection.addresses)
          PeerAddress(
            address: address,
            port: address.type == InternetAddressType.IPv4
                ? router.connection.ipv4Port
                : router.connection.ipv6Port,
          )
      ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await router.run();
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
      await router.stop();
      _mDNSsubscription?.cancel();
      await _mDNSbroadcast?.stop();
      await _mDNSdiscovery?.stop();
      _mDNSbroadcast = null;
      _mDNSdiscovery = null;
    }
  }

  @override
  Uint64List topics() =>
      Uint64List.fromList([_topicOfRecoveryGroup, _topicOfGuardian]);

  @override
  void onMessage(Header header, Uint8List data, Peer peer) {
    if (data.isEmpty) return;

    final message = MessageModel.tryFromBytes(data);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    if (message.peerId != PeerId(token: header.srcKey.data)) return;

    switch (header.topic) {
      case _topicOfGuardian:
        _guardianStreamController.add(message);
        break;
      case _topicOfRecoveryGroup:
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
      final peerId =
          PubKey(base64Decode(eventMap['service.attributes']?[_bonsoirAttr]));
      if (peerId == router.pubKey) return;
      router.addPeer(
        peerId,
        Peer(InternetAddress(eventMap['service.ip']), event.service!.port),
        enableSearch: false,
      );
      router.pingPeer(peerId);
    }
  }

  void setBootstrapServer(String? ipV4, String? ipV6, [int bsPort = 4349]) {
    final isProxyEnabled = ipV4 != null && ipV6 != null;

    Settings.enableBootstrapProxy = isProxyEnabled;
    Settings.enableBootstrapSearch = isProxyEnabled;

    router.setBootstrapServer(
      ipV4 == null ? null : Peer(InternetAddress(ipV4), bsPort),
      ipV6 == null ? null : Peer(InternetAddress(ipV6), bsPort),
    );
  }

  void addPeer(PeerId peerId, Uint8List address, {bool enableSearch = false}) {
    final ip = InternetAddress.fromRawAddress(address);

    router.addPeer(
      PubKey(peerId.token),
      Peer(
        ip,
        ip.type == InternetAddressType.IPv4
            ? router.connection.ipv4Port
            : router.connection.ipv6Port,
      ),
      enableSearch: enableSearch,
    );
  }

  bool getPeerStatus(PeerId peerId) =>
      router.getPeerStatus(PubKey(peerId.token));

  Future<bool> pingPeer({
    required PeerId peerId,
    bool staticCheck = true,
    Duration? timeout,
  }) =>
      router.pingPeer(
        PubKey(peerId.token),
        staticCheck: staticCheck,
        timeout: timeout,
      );

  StreamSubscription<bool> onPeerStatusChanged(
    void Function(bool) callback,
    PeerId peerId,
  ) =>
      router.onPeerStatusChanged(callback, PubKey(peerId.token));

  Future<void> sendToRecoveryGroup({
    required PeerId peerId,
    required MessageModel message,
    bool withAck = true,
  }) =>
      router
          .sendTo(
            _topicOfRecoveryGroup,
            PubKey(peerId.token),
            message.toBytes(),
            ack: withAck ? Ack.required : Ack.no,
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);

  Future<void> sendToGuardian({
    required PeerId peerId,
    required MessageModel message,
    bool withAck = true,
  }) =>
      router
          .sendTo(
            _topicOfGuardian,
            PubKey(peerId.token),
            message.toBytes(),
            ack: withAck ? Ack.required : Ack.no,
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);
}

Future<void> initCrypto() => P2PCrypto().init();

Future<KeyBunch> generateKeyBunch() async {
  final encryptionAesKey = (await P2PCrypto().encryptionKeyPair()).pubKey;
  final encryptionKeyPair = await P2PCrypto().encryptionKeyPair();
  final signKeyPair = await P2PCrypto().signKeyPair();

  return KeyBunch(
    encryptionPrivateKey: encryptionKeyPair.secretKey,
    encryptionPublicKey: encryptionKeyPair.pubKey,
    singPrivateKey: signKeyPair.secretKey,
    singPublicKey: signKeyPair.pubKey,
    encryptionAesKey: encryptionAesKey,
  );
}
