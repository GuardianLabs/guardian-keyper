import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:nsd/nsd.dart';

import '/src/core/consts.dart';
import '/src/core/data/core_model.dart';

part 'network_service_mdns_handler.dart';
part 'network_service_connectivity_handler.dart';

class NetworkService with ConnectivityHandler, MdnsHandler {
  NetworkService()
      : _router = p2p.RouterL2(
          logger: kDebugMode ? print : null,
          keepalivePeriod: keepalivePeriod,
        )
          ..maxForwardsLimit = maxForwardsLimit
          ..maxStoredHeaders = maxStoredHeaders;

  Duration get messageTTL => _router.messageTTL;

  PeerId get myPeerId => PeerId(token: _router.selfId.value);

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      _router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  @override
  final p2p.RouterL2 _router;

  final _messagesController = StreamController<MessageModel>.broadcast();

  p2p.Route? _bsServer;

  Future<Uint8List> init(Uint8List? seed) async {
    final cryptoKeys = await _router
        .init(seed == null ? null : (p2p.CryptoKeys.empty()..seed = seed));
    _router.messageStream.listen(onMessage);
    await _connectivityInit();
    await _initMdns();
    if (kDebugMode) print(_router.selfId);

    return cryptoKeys.seed;
  }

  Future<void> start([void _]) async {
    _connectivityType = await _connectivity.checkConnectivity();
    if (kDebugMode) print(_connectivityType);
    if (_connectivityType == ConnectivityResult.none) return;
    await _startMdns();
    await _router.start();
    if (_bsServer != null) {
      _router.sendMessage(
        dstPeerId: _bsServer!.peerId,
        useAddresses: _bsServer!.addresses.keys,
      );
    }
  }

  Future<void> pause([void _]) async {
    _router.stop();
    await _pauseMdns();
  }

  Future<void> stop([void _]) async {
    _router.stop();
    await _stopMdns();
  }

  void onMessage(final p2p.Message p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  bool getPeerStatus(final PeerId peerId) =>
      _router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(final PeerId peerId) =>
      _router.pingPeer(p2p.PeerId(value: peerId.token));

  Future<void> sendTo({
    required final PeerId peerId,
    required final MessageModel message,
    required final bool isConfirmable,
  }) async {
    try {
      await _router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } catch (_) {
      if (isConfirmable) rethrow;
    }
  }

  void removeBootstrapServer(final String peerId) =>
      _router.removePeerAddress(p2p.PeerId(value: base64Decode(peerId)));

  void addBootstrapServer(
    final String peerId, {
    final String ipV4 = '',
    final String ipV6 = '',
    final int? port,
  }) {
    final bsPeerId = p2p.PeerId(value: base64Decode(peerId));
    _bsServer = p2p.Route(
      peerId: bsPeerId,
      canForward: true,
      addresses: {
        p2p.FullAddress(
          address: InternetAddress(ipV4),
          port: port ?? defaultPort,
        ): p2p.AddressProperties(isStatic: true),
        p2p.FullAddress(
          address: InternetAddress(ipV6),
          port: port ?? defaultPort,
        ): p2p.AddressProperties(isStatic: true),
      },
    );
    _router.routes[bsPeerId] = _bsServer!;
    if (kDebugMode) {
      print('See ${_router.routes.length} existing routes');
      print('Bootstrap addresses: ${_router.routes[bsPeerId]?.addresses}');
    }
    if (_router.isRun) _router.sendMessage(dstPeerId: bsPeerId);
  }
}
