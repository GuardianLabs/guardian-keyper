import 'dart:typed_data';
import 'dart:async';
import 'package:p2plib/p2plib.dart';
import 'keeper_packet.dart';
import 'owner_packet.dart';
import 'keeper_handler.dart';

class OwnerHandler extends TopicHandler {
  static const defaultTimeout = Duration(seconds: 10);
  static const topic = 100;
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
  Uint64List topics() {
    // подписываемся на сообщения от хранителя
    return Uint64List.fromList([KeeperHandler.topic]);
  }

  // оправить фрагмент данных на хранение
  Future<void> sendShardSave(PubKey peer, Uint8List data,
      {Duration timeout = defaultTimeout}) async {
    final completer = Completer();
    _statusCompleters[peer] = completer;

    final header = Header(topic, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.setShard, data);
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    try {
      await router.send(peer, msg);
    } catch (err) {
      rethrow;
    }
    return completer.future.timeout(timeout, onTimeout: () {
      _statusCompleters.remove(peer);
      throw TimeoutException('[OwnerHandler] send shard request timeout');
    });
  }

  // отправить запрос на добавление кипера
  Future<void> sendAddKeeperRequest(PubKey peer, Uint8List token,
      {Duration timeout = defaultTimeout}) async {
    final completer = Completer();
    _statusCompleters[peer] = completer;
    final header = Header(topic, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.authPeer, token);
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    try {
      await router.send(peer, msg);
    } catch (err) {
      rethrow;
    }
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
    final header = Header(topic, router.pubKey, peer);
    final body = OwnerBody(OwnerMsgType.getShard, Uint8List(0));
    final encryptedBody =
        P2PCrypto.encrypt(peer, router.keyPair.secretKey, body.serialize());
    final msg = OwnerPacket(header, encryptedBody).serialize();
    try {
      await router.send(peer, msg);
    } catch (err) {
      rethrow;
    }
    return completer.future.timeout(timeout, onTimeout: () {
      _dataCompleters.remove(peer);
      throw TimeoutException('[OwnerHandler] request shard timeout');
    });
  }

  void _onPacket(Header header, KeeperBody body) {
    switch (body.msgType) {
      case KeeperMsgType.addKeeperResult:
      case KeeperMsgType.saveDataResult:
        {
          final completer = _statusCompleters[header.srcKey];
          if (null == completer) {
            // print('[OwnerHandler] no completer for the status operation');
            return;
          }
          final status = ProcessStatus.values[body.data[0]];
          if (status == ProcessStatus.success) {
            completer.complete();
          } else {
            completer.completeError(status);
          }
          _statusCompleters.remove(header.srcKey);
          break;
        }
      case KeeperMsgType.data:
        {
          final completer = _dataCompleters[header.srcKey];
          if (null == completer) {
            // print('[OwnerHandler] no completer for the get data operation');
            return;
          }

          completer.complete(body.data);
          _dataCompleters.remove(header.srcKey);
          break;
        }
    }
  }
}
