import 'dart:typed_data';

import 'package:p2plib/p2plib.dart';
import 'owner_handler.dart';
import 'owner_packet.dart';
import 'keeper_packet.dart';

class KeeperHandler extends TopicHandler {
  static const topic = 101;

  void Function(PubKey owner, Uint8List token) onAuthRequest;
  void Function(PubKey owner, Uint8List data) onSetRequest;
  void Function(PubKey owner) onGetRequest;

  KeeperHandler({
    required Router router,
    required this.onAuthRequest,
    required this.onSetRequest,
    required this.onGetRequest,
  }) : super(router);

  @override
  void onStarted() {}

  @override
  Uint64List topics() {
    // подписываемся на сообщения от владельца
    return Uint64List.fromList([OwnerHandler.topic]);
  }

  @override
  void onMessage(Uint8List data, Peer peer) {
    final packet = OwnerPacket.deserialize(data);
    final body = OwnerBody.deserialize(P2PCrypto.decrypt(
        packet.header.srcKey, router.keyPair.secretKey, packet.body));

    switch (body.type) {
      case OwnerMsgType.authPeer:
        onAuthRequest(packet.header.srcKey, body.data);
        break;
      case OwnerMsgType.setShard:
        onSetRequest(packet.header.srcKey, body.data);
        break;
      case OwnerMsgType.getShard:
        onGetRequest(packet.header.srcKey);
        break;
    }
  }

  Future<void> sendAuthStatus(PubKey owner, ProcessStatus status) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody.createAddKeeperStatus(status);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    await router.send(owner, data);
  }

  Future<void> sendSaveStatus(PubKey owner, ProcessStatus status) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody.createSaveDataStatus(status);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    await router.send(owner, data);
  }

  void sendShard(PubKey owner, Uint8List shard) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody(KeeperMsgType.data, shard);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    try {
      await router.send(owner, data);
    } finally {}
  }
}
