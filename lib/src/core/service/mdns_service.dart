import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';
import 'package:bonsoir/bonsoir.dart';

import '/src/core/utils/random_utils.dart';

class MdnsService extends TopicHandler with WidgetsBindingObserver {
  static const _topicServiceDiscovery = 77;

  final MdnsBroadcastDiscovery mdnsBroadcastDiscover;
  final _completers = <RawToken, Completer>{};
  final _peerEvents = StreamController<_MdnsEvent>.broadcast();

  MdnsService({
    required Router router,
    required this.mdnsBroadcastDiscover,
  }) : super(router) {
    WidgetsBinding.instance.addObserver(this);
    mdnsBroadcastDiscover.discovery.stream.listen(_onDiscoveryEvent);
    Future.microtask(mdnsBroadcastDiscover.run);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await mdnsBroadcastDiscover.run();
    } else {
      await mdnsBroadcastDiscover.stop();
    }
  }

  @override
  Uint64List topics() => Uint64List.fromList([_topicServiceDiscovery]);

  @override
  void onMessage(Header header, Uint8List data, Peer peer) {
    if (header.dstKey != router.pubKey) return;
    try {
      final packet = _ConfirmationPacket.deserialize(data);
      switch (packet.type) {
        case _MsgType.answer:
          final token = RawToken(data: packet.id, len: packet.id.length);
          final completer = _completers[token];
          if (completer != null) {
            router.addPeer(header.srcKey, peer);
            _peerEvents.add(_MdnsEvent(header.srcKey, peer));
            completer.complete(peer);
            _completers.remove(token);
          }
          break;

        case _MsgType.request:
          router.addPeer(header.srcKey, peer);
          _peerEvents.add(_MdnsEvent(header.srcKey, peer));
          router.sendEncrypted(
            _topicServiceDiscovery,
            peer,
            _ConfirmationPacket(_MsgType.answer, packet.id).serialize(),
            dstKey: header.srcKey,
          );
          break;
      }
    } catch (_) {}
  }

  void _onDiscoveryEvent(_DiscoveryEvent event) async {
    try {
      final pubKeyData = base64Decode(event.pubKey);
      if (pubKeyData.length != PubKey.length) return;

      final pubKey = PubKey(pubKeyData);
      if (pubKey == router.pubKey) return;

      final ip = InternetAddress(event.ip);
      final peer = ip.type == InternetAddressType.IPv4
          ? Peer(ip, router.connection.ipv4Port)
          : Peer(ip, router.connection.ipv6Port);

      await _confirmPeer(pubKey.data, peer);
      router.addPeer(pubKey, peer);
    } catch (_) {}
  }

  Future<void> _confirmPeer(
    Uint8List pubkey,
    Peer peer, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final token = RawToken(data: getRandomBytes(64), len: 64);
    _completers[token] = Completer();
    await router.sendEncrypted(
      _topicServiceDiscovery,
      peer,
      _ConfirmationPacket(_MsgType.request, token.data).serialize(),
      dstKey: PubKey(pubkey),
    );
    return _completers[token]!.future.timeout(
      timeout,
      onTimeout: () {
        _completers.remove(token);
        throw TimeoutException('[BroadcastFinder] Request timeout');
      },
    );
  }
}

class MdnsBroadcastDiscovery {
  static const _serviceName = '_dartshare._udp';
  static const _port = 3264;

  final discovery = StreamController<_DiscoveryEvent>.broadcast();

  late String deviceName;
  late String pubKeyAttribute;

  BonsoirBroadcast? _broadcastService;
  BonsoirDiscovery? _discoveryService;

  MdnsBroadcastDiscovery(PubKey pubKey) {
    final encodedKey = base64Encode(pubKey.data);
    deviceName = encodedKey.substring(0, 8);
    pubKeyAttribute = encodedKey;
  }

  Future<void> run() async {
    try {
      await _startService();
      await _startDiscovery();
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _broadcastService?.stop();
      await _discoveryService?.stop();
    } catch (_) {
    } finally {
      _broadcastService = null;
      _discoveryService = null;
    }
  }

  Future<void> _startService() async {
    _broadcastService ??= BonsoirBroadcast(
      service: BonsoirService(
        name: deviceName,
        type: _serviceName,
        port: _port,
        attributes: {'pubKey': pubKeyAttribute},
      ),
    );
    await _broadcastService!.ready;
    await _broadcastService!.start();
  }

  Future<void> _startDiscovery() async {
    _discoveryService ??= BonsoirDiscovery(type: _serviceName);
    await _discoveryService!.ready;
    await _discoveryService!.start();
    _discoveryService!.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved &&
          event.service != null) {
        final value = event.service!.toJson();
        final String? ip = value['service.ip'];
        final String? pubKey = value['service.attributes']?['pubKey'];
        if (ip == null || pubKey == null) return;
        discovery.add(_DiscoveryEvent(ip, pubKey));
      }
    });
  }
}

enum _MsgType { request, answer }

class _MdnsEvent {
  final PubKey pubKey;
  final Peer peer;

  const _MdnsEvent(this.pubKey, this.peer);
}

class _DiscoveryEvent {
  final String ip;
  final String pubKey;

  const _DiscoveryEvent(this.ip, this.pubKey);
}

class _ConfirmationPacket {
  final _MsgType type;
  final Uint8List id;

  const _ConfirmationPacket(this.type, this.id);

  factory _ConfirmationPacket.deserialize(Uint8List data) {
    final bytes = ByteData.view(data.buffer);
    if (bytes.lengthInBytes < 1) throw const FormatException();
    return _ConfirmationPacket(
      _MsgType.values[bytes.getUint8(0)],
      data.sublist(1),
    );
  }

  Uint8List serialize() {
    final bytes = ByteData(1 + id.length);
    var offset = 0;
    bytes.setUint8(offset++, type.index);
    for (var byte in id) {
      bytes.setInt8(offset++, byte);
    }
    return bytes.buffer.asUint8List();
  }
}
