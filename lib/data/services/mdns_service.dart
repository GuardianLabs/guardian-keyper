import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:nsd/nsd.dart' as nsd;
import 'package:flutter/foundation.dart';

import '../../consts.dart';

class MdnsService {
  static const _mdnsPeerId = 'peerId';
  static const _mdnsType = '_guardianKeyper._udp';
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  MdnsService({required this.onPeerFound});

  final void Function(
    Uint8List peerId,
    InternetAddress address,
    int? port,
  ) onPeerFound;

  nsd.Registration? _registration;
  nsd.Discovery? _discovery;

  Future<void> register(Uint8List peerId, int port) async {
    try {
      _registration = await nsd
          .register(nsd.Service(
            name: 'Guardian Keyper',
            type: _mdnsType,
            port: port,
            txt: {
              _mdnsPeerId: _utf8Encoder.convert(base64Encode(peerId)),
            },
          ))
          .timeout(initTimeout);
    } on nsd.NsdError catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> unregister() async {
    if (_registration != null) await nsd.unregister(_registration!);
  }

  Future<void> startDiscovery() async {
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

  void _onEvent(
    nsd.Service service,
    nsd.ServiceStatus status,
  ) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;

    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null || peerIdBytes.isEmpty) return;

    if (status == nsd.ServiceStatus.found) {
      for (final address in service.addresses!) {
        if (address.isLinkLocal || address.address.isEmpty) continue;
        onPeerFound(
          base64Decode(_utf8Decoder.convert(peerIdBytes)),
          address,
          service.port,
        );
      }
    }
  }
}
