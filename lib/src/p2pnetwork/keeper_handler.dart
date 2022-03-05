import 'dart:typed_data';
import 'package:p2plib/p2plib.dart';

import 'owner_handler.dart';
import 'owner_packet.dart';
import 'keeper_packet.dart';

class KeeperHandler extends TopicHandler {
  static const topic = 101;

  Future<bool> Function(PubKey owner, Uint8List token) onAuthRequest;
  Future<bool> Function(PubKey owner, Uint8List data) onSetRequest;
  Future<Uint8List> Function(PubKey owner) onGetRequest;

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
  void onMessage(Uint8List data, Peer peer) async {
    final packet = OwnerPacket.deserialize(data);
    final owner = packet.header.srcKey;
    final body = OwnerBody.deserialize(
        P2PCrypto.decrypt(owner, router.keyPair.secretKey, packet.body));

    switch (body.type) {
      case OwnerMsgType.authPeer:
        _sendResponse(
            owner,
            KeeperBody.createAuthStatus(await onAuthRequest(owner, body.data)
                ? ProcessStatus.success
                : ProcessStatus.reject));
        break;
      case OwnerMsgType.setShard:
        _sendResponse(
            owner,
            KeeperBody.createSaveDataStatus(await onSetRequest(owner, body.data)
                ? ProcessStatus.success
                : ProcessStatus.reject));
        break;
      case OwnerMsgType.getShard:
        _sendResponse(
            owner, KeeperBody(KeeperMsgType.data, await onGetRequest(owner)));
        break;
    }
  }

  void _sendResponse(PubKey owner, KeeperBody body) => router.send(
      owner,
      KeeperPacket(
        Header(topic, router.pubKey, owner),
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize()),
      ).serialize());
}
