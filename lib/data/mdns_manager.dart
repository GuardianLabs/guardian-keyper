import 'dart:async';
import 'dart:convert';
import 'package:nsd/nsd.dart' as nsd;
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../app/consts.dart';
import 'platform_manager.dart';

class MdnsManager {
  static const _mdnsPeerId = 'peerId';
  static const _mdnsType = '_guardianKeyper._udp';
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  MdnsManager({
    final int port = defaultPort,
    required final p2p.RouterL2 router,
  })  : _port = port,
        _router = router;

  final int _port;
  final p2p.RouterL2 _router;

  final _platformManager = GetIt.I<PlatformManager>();

  late final nsd.Registration _registration;

  nsd.Discovery? _discovery;

  Future<MdnsManager> init() async {
    try {
      _registration = await nsd
          .register(nsd.Service(
            name: 'Guardian Keyper',
            type: _mdnsType,
            port: _port,
            txt: {
              _mdnsPeerId:
                  _utf8Encoder.convert(base64Encode(_router.selfId.value)),
            },
          ))
          .timeout(initTimeout);
    } on nsd.NsdError catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
    return this;
  }

  Future<void> startDiscovery() async {
    if (_platformManager.hasWiFi) {
      try {
        _discovery ??= await nsd
            .startDiscovery(_mdnsType, ipLookupType: nsd.IpLookupType.any)
            .timeout(initTimeout)
          ..addServiceListener(_onEvent);
      } on nsd.NsdError catch (e) {
        if (kDebugMode) print(e);
        rethrow;
      } on TimeoutException catch (e) {
        if (kDebugMode) print(e);
      }
    }
  }

  Future<void> stopDiscovery() async {
    if (_discovery == null) return;
    final discovery = _discovery!;
    _discovery = null;
    try {
      await nsd.stopDiscovery(discovery);
      discovery.dispose();
    } on nsd.NsdError catch (e) {
      if (kDebugMode) print(e);
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  /// Must be called on app stops
  Future<void> dispose() async {
    await stopDiscovery();
    await nsd.unregister(_registration);
  }

  void _onEvent(final nsd.Service service, final nsd.ServiceStatus status) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;
    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null) return;
    if (status == nsd.ServiceStatus.found) {
      final peerId = p2p.PeerId(
        value: base64Decode(_utf8Decoder.convert(peerIdBytes)),
      );
      final props = p2p.AddressProperties(isLocal: true, isStatic: true);
      for (final address in service.addresses!) {
        _router.addPeerAddress(
          peerId: peerId,
          properties: props,
          address: p2p.FullAddress(address: address, port: _port),
        );
      }
    }
  }
}
