part of '../p2p_network_service.dart';

mixin P2PMdnsHandler on P2PNetworkServiceBase {
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';
  late final _service = Service(
    name: 'Guardian Keyper',
    type: _mdnsType,
    port: bindPort,
    txt: {_mdnsPeerId: _utf8Encoder.convert(base64Encode(router.selfId.value))},
  );

  Future<void> _initMdns() async {
    await register(_service);
    final discovery = await startDiscovery(
      _mdnsType,
      ipLookupType: IpLookupType.any,
    );
    discovery.addServiceListener(_onEvent);
  }

  void _onEvent(Service service, ServiceStatus status) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;
    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null) return;
    if (status == ServiceStatus.found) {
      router.addPeerAddresses(
        canForward: false,
        peerId: p2p.PeerId(
          value: base64Decode(_utf8Decoder.convert(peerIdBytes)),
        ),
        addresses: service.addresses!.map((e) => p2p.FullAddress(
              address: e,
              port: service.port!,
              isStatic: true,
              isLocal: true,
            )),
      );
    }
  }
}
