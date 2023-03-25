part of 'network_service.dart';

mixin MdnsHandler on NetworkServiceBase {
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';
  late final _service = Service(
    name: 'Guardian Keyper',
    type: _mdnsType,
    port: defaultPort,
    txt: {_mdnsPeerId: _utf8Encoder.convert(base64Encode(router.selfId.value))},
  );

  Future<void> _initMdns() async {
    // TBD: unregister onDispose
    try {
      await register(_service).timeout(const Duration(seconds: 3));
    } on NsdError catch (e) {
      if (kDebugMode) print(e);
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
    final discovery = await startDiscovery(
      _mdnsType,
      ipLookupType: IpLookupType.any,
    ).timeout(const Duration(seconds: 3));
    discovery.addServiceListener(_onEvent);
  }

  void _onEvent(Service service, ServiceStatus status) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;
    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null) return;
    if (status == ServiceStatus.found) {
      for (final address in service.addresses!) {
        router.addPeerAddress(
          peerId: p2p.PeerId(
            value: base64Decode(_utf8Decoder.convert(peerIdBytes)),
          ),
          address: p2p.FullAddress(address: address, port: service.port!),
          properties: p2p.AddressProperties(isStatic: true, isLocal: true),
        );
      }
    }
  }
}
