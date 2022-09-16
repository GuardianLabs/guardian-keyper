import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../model/core_model.dart';
import 'mdns_service.dart';

class NetworkService extends TopicHandler with WidgetsBindingObserver {
  static const _topicOfRecoveryGroup = 100;
  static const _topicOfGuardian = 101;

  final _guardianStreamController = StreamController<MessageModel>.broadcast();
  final _recoveryGroupStreamController =
      StreamController<MessageModel>.broadcast();

  NetworkService({
    required Router router,
    bool useMdnsService = true,
  }) : super(router) {
    WidgetsBinding.instance.addObserver(this);
    if (useMdnsService) {
      MdnsService(
        router: router,
        mdnsBroadcastDiscover: MdnsBroadcastDiscovery(router.pubKey),
      );
    }
    Future.microtask(router.run);
  }

  factory NetworkService.udp({
    required KeyBunch keyBunch,
    String? bsAddressV4,
    String? bsAddressV6,
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
          bootstrapServerAddress: bsAddressV4 != null
              ? Peer(
                  InternetAddress(bsAddressV4, type: InternetAddressType.IPv4),
                  bsPort,
                )
              : null,
          bootstrapServerAddressIpv6: bsAddressV6 != null
              ? Peer(
                  InternetAddress(bsAddressV6, type: InternetAddressType.IPv6),
                  bsPort,
                )
              : null,
        ),
      );

  PeerId get myPeerId => PeerId(value: router.pubKey.data);

  List<InternetAddress> get myIPs => router.connection.addresses;

  Stream<MessageModel> get guardianStream => _guardianStreamController.stream;

  Stream<MessageModel> get recoveryGroupStream =>
      _recoveryGroupStreamController.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async =>
      state == AppLifecycleState.resumed
          ? await router.run()
          : await router.stop();

  @override
  Uint64List topics() =>
      Uint64List.fromList([_topicOfRecoveryGroup, _topicOfGuardian]);

  @override
  void onMessage(Header header, Uint8List data, Peer peer) {
    if (data.isEmpty) return;
    switch (header.topic) {
      case _topicOfGuardian:
        _guardianStreamController.add(
            MessageModel.fromBytes(data, PeerId(value: header.srcKey.data)));
        break;
      case _topicOfRecoveryGroup:
        _recoveryGroupStreamController.add(
            MessageModel.fromBytes(data, PeerId(value: header.srcKey.data)));
        break;
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
      PubKey(peerId.value),
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
      router.getPeerStatus(PubKey(peerId.value));

  Future<bool> pingPeer({
    required PeerId peerId,
    bool staticCheck = true,
    Duration? timeout,
  }) =>
      router.pingPeer(
        PubKey(peerId.value),
        staticCheck: staticCheck,
        timeout: timeout,
      );

  StreamSubscription<bool> onPeerStatusChanged(
    void Function(bool) callback,
    PeerId peerId,
  ) =>
      router.onPeerStatusChanged(callback, PubKey(peerId.value));

  Future<void> sendToRecoveryGroup(MessageModel message, {withAck = true}) =>
      router
          .sendTo(
            _topicOfRecoveryGroup,
            PubKey(message.peerId.value),
            message.toBytes(),
            ack: withAck ? Ack.required : Ack.no,
          )
          .catchError((_) {}, test: (e) => e is TimeoutException);

  Future<void> sendToGuardian(MessageModel message, {withAck = true}) => router
      .sendTo(
        _topicOfGuardian,
        PubKey(message.peerId.value),
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
