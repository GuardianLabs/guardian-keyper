part of 'network_service.dart';

mixin MdnsHandler {
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  p2p.RouterL2 get _router;

  int get defaultPort => p2p.TransportUdp.defaultPort;

  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';

  late final Registration _registration;
  late final _service = Service(
    name: 'Guardian Keyper',
    type: _mdnsType,
    port: defaultPort,
    txt: {
      _mdnsPeerId: _utf8Encoder.convert(base64Encode(_router.selfId.value))
    },
  );

  late Discovery _discovery;

  Future<void> _initMdns() async {
    try {
      _registration = await register(_service).timeout(
        const Duration(seconds: 3),
      );
    } on NsdError catch (e) {
      if (kDebugMode) print(e);
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _startMdns() async {
    _discovery = await startDiscovery(
      _mdnsType,
      ipLookupType: IpLookupType.any,
    ).timeout(const Duration(seconds: 3));
    _discovery.addServiceListener(_onEvent);
  }

  Future<void> _pauseMdns() => stopDiscovery(_discovery);

  Future<void> _stopMdns() => unregister(_registration);

  void _onEvent(Service service, ServiceStatus status) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;
    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null) return;
    if (status == ServiceStatus.found) {
      for (final address in service.addresses!) {
        _router.addPeerAddress(
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
