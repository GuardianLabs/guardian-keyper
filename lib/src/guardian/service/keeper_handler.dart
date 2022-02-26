import 'dart:typed_data';

import 'package:p2plib/p2plib.dart';
import 'owner_handler.dart';
import 'owner_packet.dart';
import 'keeper_packet.dart';

class KeeperHandler extends TopicHandler {
  static const topic = 101;

  Function(PubKey owner, Uint8List token)? onAddKeeperRequest;
  Function(PubKey owner, Uint8List data)? onSaveRequest;
  Function(PubKey owner)? onGetRequest;

  KeeperHandler(Router router) : super(router);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final packet = OwnerPacket.deserialize(data);
    final body = OwnerBody.deserialize(P2PCrypto.decrypt(
        packet.header.srcKey, router.keyPair.secretKey, packet.body));

    _onPacket(packet.header, body);
  }

  @override
  void onStarted() {}

  @override
  Uint64List topics() {
    // подписываемся на сообщения от владельца
    return Uint64List.fromList([OwnerHandler.topic]);
  }

  void sendAddKeeperStatus(PubKey owner, ProcessStatus status) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody.createAddKeeperStatus(status);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    try {
      await router.send(owner, data);
    } catch (err) {
      rethrow;
    }
  }

  void sendSaveStatus(PubKey owner, ProcessStatus status) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody.createSaveDataStatus(status);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    try {
      await router.send(owner, data);
    } catch (err) {
      rethrow;
    }
  }

  void sendShard(PubKey owner, Uint8List shard) async {
    final header = Header(topic, router.pubKey, owner);
    final body = KeeperBody(KeeperMsgType.data, shard);
    final encryptedBody =
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize());
    final data = KeeperPacket(header, encryptedBody).serialize();
    try {
      await router.send(owner, data);
    } catch (err) {
      rethrow;
    }
  }

  void _onPacket(Header header, OwnerBody body) {
    switch (body.type) {
      case OwnerMsgType.addKeeper:
        onAddKeeperRequest?.call(header.srcKey, body.data);
        break;
      case OwnerMsgType.saveShard:
        onSaveRequest?.call(header.srcKey, body.data);
        break;
      case OwnerMsgType.getShard:
        onGetRequest?.call(header.srcKey);
        break;
    }
  }
}
