import 'dart:typed_data';
import 'dart:async';
import 'package:p2plib/p2plib.dart';

import '../core/model/keeper_packet.dart';
import '../core/model/owner_packet.dart';

class OwnerHandler extends TopicHandler {
  static const _topicOfThis = 100;
  static const _topicSubscribeTo = 101;
  static const defaultTimeout = Duration(seconds: 10);

  final Map<PubKey, Completer> _statusCompleters = {};
  final Map<PubKey, Completer<Uint8List>> _dataCompleters = {};

  OwnerHandler(Router router) : super(router);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final packet = KeeperPacket.deserialize(data);
    final body = KeeperBody.deserialize(P2PCrypto.decrypt(
        packet.header.srcKey, router.keyPair.secretKey, packet.body));
    _onPacket(packet.header, body);
  }

  @override
  void onStarted() {}

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  // оправить фрагмент данных на хранение
  Future<void> sendSetShardRequest(PubKey peer, Uint8List data,
      {Duration timeout = defaultTimeout}) async {
    final completer = Completer();
    _statusCompleters[peer] = completer;

    final header = Header(_topicOfThis, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.setShard, data);
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    await router.send(peer, msg);

    return completer.future.timeout(timeout, onTimeout: () {
      _statusCompleters.remove(peer);
      throw TimeoutException('[OwnerHandler] send shard request timeout');
    });
  }

  // отправить запрос на добавление кипера
  Future<void> sendAuthRequest(PubKey peer, Uint8List token,
      {Duration timeout = defaultTimeout}) async {
    final completer = Completer();
    _statusCompleters[peer] = completer;
    final header = Header(_topicOfThis, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.authPeer, token);
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    await router.send(peer, msg);

    return completer.future.timeout(timeout, onTimeout: () {
      _statusCompleters.remove(peer);
      throw TimeoutException('[OwnerHandler] add keeper request timeout');
    });
  }

  // оправить запрос на получение фрагмента данных
  Future<Uint8List> sendShardRequest(PubKey peer,
      {Duration timeout = defaultTimeout}) async {
    final completer = Completer<Uint8List>();
    _dataCompleters[peer] = completer;
    final header = Header(_topicOfThis, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.getShard, Uint8List(0));
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    await router.send(peer, msg);

    return completer.future.timeout(timeout, onTimeout: () {
      _dataCompleters.remove(peer);
      throw TimeoutException('[OwnerHandler] request shard timeout');
    });
  }

  void _onPacket(Header header, KeeperBody body) {
    switch (body.msgType) {
      case KeeperMsgType.addKeeperResult:
        break;
      case KeeperMsgType.saveDataResult:
        final completer = _statusCompleters[header.srcKey];
        if (completer == null) return;

        final status = ProcessStatus.values[body.data[0]];
        status == ProcessStatus.success
            ? completer.complete()
            : completer.completeError(status);

        _statusCompleters.remove(header.srcKey);
        break;
      case KeeperMsgType.data:
        final completer = _dataCompleters[header.srcKey];
        if (completer == null) return;

        completer.complete(body.data);
        _dataCompleters.remove(header.srcKey);
        break;
    }
  }
}
