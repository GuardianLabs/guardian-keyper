import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:nsd/nsd.dart';

import '/src/core/consts.dart';
import '/src/core/model/core_model.dart';

export 'package:get_it/get_it.dart';

part 'p2p_network_service/p2p_network_service_base.dart';
part 'p2p_network_service/p2p_network_service_mdns_handler.dart';
part 'p2p_network_service/p2p_network_service_connectivity_handler.dart';

class P2PNetworkService extends P2PNetworkServiceBase
    with WidgetsBindingObserver, P2PConnectivityHandler, P2PMdnsHandler {
  final _messagesController = StreamController<MessageModel>.broadcast();

  p2p.Route? _bsServer;

  Stream<MessageModel> get messageStream => _messagesController.stream;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await start();
    } else {
      await stop();
    }
  }

  Future<Uint8List> init(Uint8List seed) async {
    WidgetsBinding.instance.addObserver(this);

    for (final interface in await NetworkInterface.list()) {
      _myAddresses.addAll(interface.addresses.map(
        (a) => PeerAddress(address: a, port: bindPort),
      ));
    }

    final cryptoKeys = await router.init(p2p.CryptoKeys.empty()..seed = seed);
    router.messageStream.listen(onMessage);
    await _connectivityInit();
    await _initMdns();
    if (kDebugMode) {
      print(_myAddresses);
      print(router.selfId);
    }
    return cryptoKeys.seed;
  }

  Future<void> start([void _]) async {
    _connectivityType = await _connectivity.checkConnectivity();
    if (kDebugMode) print(_connectivityType);
    if (_connectivityType == ConnectivityResult.none) return;
    await router.start();
    if (_bsServer != null) router.sendMessage(dstPeerId: _bsServer!.peerId);
  }

  Future<void> stop([void _]) async {
    router.stop();
  }

  void onMessage(final p2p.Message p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  void addBootstrapServer({
    required String peerId,
    String ipV4 = '',
    String ipV6 = '',
    int? port,
  }) {
    final bsPeerId = p2p.PeerId(value: base64Decode(peerId));
    if (ipV4.isEmpty && ipV6.isEmpty) {
      _bsServer = null;
      router.removePeerAddress(bsPeerId);
    } else {
      _bsServer = p2p.Route(
        peerId: bsPeerId,
        canForward: true,
        addresses: {
          if (ipV4.isNotEmpty && myAddresses.any((e) => e.isIPv4))
            p2p.FullAddress(
              address: InternetAddress(ipV4),
              port: port ?? bindPort,
            ): p2p.AddressProperties(isStatic: true),
          if (ipV6.isNotEmpty && myAddresses.any((e) => e.isIPv6))
            p2p.FullAddress(
              address: InternetAddress(ipV6),
              port: port ?? bindPort,
            ): p2p.AddressProperties(isStatic: true),
        },
      );
      router.routes[bsPeerId] = _bsServer!;
      if (kDebugMode) {
        print('See ${router.routes.length} existing routes');
        print('Bootstrap addresses: ${router.routes[bsPeerId]?.addresses}');
      }
      if (router.isRun) router.sendMessage(dstPeerId: bsPeerId);
    }
  }
}
