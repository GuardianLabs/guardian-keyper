part of 'network_service.dart';

mixin ConnectivityHandler on NetworkServiceBase {
  final _connectivity = Connectivity();
  final _connectivityController = StreamController<bool>.broadcast();

  late ConnectivityResult _connectivityType;

  bool get hasConnectivity => _connectivityType != ConnectivityResult.none;

  Future<bool> get checkConnectivity => _connectivity
      .checkConnectivity()
      .then((result) => result != ConnectivityResult.none);

  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<void> _connectivityInit() async {
    _connectivityType = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      if (kDebugMode) print(result);
      _connectivityType = result;
      _connectivityController.add(result != ConnectivityResult.none);
    });
  }
}

mixin MdnsHandler on NetworkServiceBase {
  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';
  final _mdnsName = 'Guardian Keyper';

  late final BonsoirService _mdnsService;
  late final BonsoirDiscovery _mdnsDiscovery;
  late final BonsoirBroadcast _mdnsBroadcast;

  Future<void> _mdnsInit(int port, String peerId) async {
    _mdnsService = BonsoirService(
      name: _mdnsName,
      type: _mdnsType,
      port: port,
      attributes: {_mdnsPeerId: peerId},
    );
    _mdnsBroadcast = BonsoirBroadcast(service: _mdnsService);
    _mdnsDiscovery = BonsoirDiscovery(type: _mdnsType);
    await _mdnsDiscovery.ready;
    _mdnsDiscovery.eventStream!.listen(_onMdnsEvent);
  }

  Future<void> startMdnsBroadcast() async {
    if (_mdnsBroadcast.isStopped) {
      await _mdnsBroadcast.ready;
      await _mdnsBroadcast.start();
    }
  }

  Future<void> stopMdnsBroadcast() => _mdnsBroadcast.stop();

  Future<void> startMdnsDiscovery() async {
    if (_mdnsDiscovery.isStopped) {
      await _mdnsDiscovery.ready;
      await _mdnsDiscovery.start();
    }
  }

  Future<void> stopMdnsDiscovery() => _mdnsDiscovery.stop();

  void _onMdnsEvent(BonsoirDiscoveryEvent event) {
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      final eventMap = event.service?.toJson();
      if (eventMap == null) return;
      if (eventMap['service.type'] != _mdnsType) return;
      if (eventMap['service.name'] != _mdnsName) return;
      final peerId = P2PPeerId(
        value: base64Decode(eventMap['service.attributes']?[_mdnsPeerId]),
      );
      if (peerId == router.selfId) return;
      router.addPeerAddress(
        peerId: peerId,
        address: P2PFullAddress(
          address: InternetAddress(eventMap['service.ip']),
          port: event.service!.port,
          isLocal: true,
        ),
      );
    }
  }
}
